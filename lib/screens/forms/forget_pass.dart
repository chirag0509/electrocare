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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final authController = Get.put(AuthController());
  final userController = Get.put(UserController());

  final TextEditingController _emailController = TextEditingController();

  bool _isEmailValid = true;

  FlutterValidation validator = FlutterValidation();

  bool isLoading = false;

  void onLinkSend() async {
    if (_emailController.text.isEmpty) {
      toastMsg("Please enter your email address");
    } else if (!_isEmailValid) {
      toastMsg("Please enter your valid email address");
    } else {
      setState(() {
        isLoading = true;
      });

      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: _emailController.text.trim())
          .get();

      if (userDoc.docs.isNotEmpty) {
        bool isLinkSent = await authController
            .sendResetPasswordMail(_emailController.text.trim());

        if (isLinkSent) {
          setState(() {
            isLoading = false;
          });
          toastMsg("Link has been sent to the provided email");
          Navigator.pop(context);
        } else {
          setState(() {
            isLoading = false;
          });
          toastMsg("Sorry, Something went wrong");
        }
      } else {
        setState(() {
          isLoading = false;
        });
        toastMsg("No account found for the given email");
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
                        heading("Reset Password"),
                        SizedBox(height: 40.h),
                        textField(size, _emailController, "Email", (value) {
                          setState(() {
                            _isEmailValid = validator.emailValidate(
                                content: _emailController.text);
                          });
                        }, false, false, !_isEmailValid),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () {
                            onLinkSend();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 13.h),
                            width: size.width * 0.6,
                            decoration: BoxDecoration(
                                color: Constants.primary,
                                borderRadius: BorderRadius.circular(50.r)),
                            child: Center(
                              child: isLoading
                                  ? SpinKitThreeBounce(
                                      color: Constants.white,
                                      size: 16.sp,
                                    )
                                  : Text(
                                      "Reset",
                                      style: Constants.poppins(16.sp,
                                          FontWeight.w500, Constants.white),
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
