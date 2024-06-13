// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/controllers/auth_controller.dart';
import 'package:electrocare/respository/controllers/user_controller.dart';
import 'package:electrocare/screens/forms/otp.dart';
import 'package:electrocare/screens/forms/resigter.dart';
import 'package:electrocare/utils/common_widgets.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:field_validation/Source_Code/FlutterValidation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Phone extends StatefulWidget {
  const Phone({super.key});

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  final authController = Get.put(AuthController());
  final userController = Get.put(UserController());

  final TextEditingController _phoneController = TextEditingController();

  bool _isPhoneValid = true;

  FlutterValidation validator = FlutterValidation();

  void onSendOTP() async {
    if (_phoneController.text.isEmpty) {
      toastMsg("Please enter your phone number");
    } else if (!_isPhoneValid) {
      toastMsg("Please enter your valid phone number");
    } else {
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("phone", isEqualTo: _phoneController.text.trim())
          .get();

      if (userDoc.docs.isNotEmpty) {
        await authController.phoneAuthentication(_phoneController.text.trim());

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPScreen(
                    phone: _phoneController.text.trim(),
                    isLogin: true,
                  )),
        );
      } else {
        toastMsg("No account found for the given number");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Constants.bg1,
        body: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(minHeight: size.height),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                      width: size.width,
                      child: SvgPicture.asset(
                        "assets/registerDesign.svg",
                        fit: BoxFit.fitWidth,
                      )),
                ),
                Positioned(
                  bottom: 30.h,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: Constants.poppins(
                            14.sp,
                            FontWeight.w500,
                            Constants.black,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "Sign-Up",
                          style: Constants.poppins(
                            14.sp,
                            FontWeight.w500,
                            Constants.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 60.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Constants.black,
                              size: 25.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 35.h),
                        heading("Sign-In"),
                        SizedBox(height: 40.h),
                        textField(size, _phoneController, "Phone", (value) {
                          setState(() {
                            _isPhoneValid = validator.mobileValidate(
                                content: _phoneController.text);
                          });
                        }, false, true, !_isPhoneValid),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () {
                            onSendOTP();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 13.h),
                            width: size.width * 0.6,
                            decoration: BoxDecoration(
                                color: Constants.primary,
                                borderRadius: BorderRadius.circular(50.r)),
                            child: Center(
                              child: Text(
                                "Send OTP",
                                style: Constants.poppins(
                                    16.sp, FontWeight.w500, Constants.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
