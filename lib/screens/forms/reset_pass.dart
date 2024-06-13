// ignore_for_file: use_build_context_synchronously

import 'package:electrocare/respository/controllers/auth_controller.dart';
import 'package:electrocare/respository/controllers/user_controller.dart';
import 'package:electrocare/utils/common_widgets.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:field_validation/Source_Code/FlutterValidation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ResetPass extends StatefulWidget {
  final String oobCode;
  const ResetPass({super.key, required this.oobCode});

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final authController = Get.put(AuthController());

  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordValid = true;

  FlutterValidation validator = FlutterValidation();

  bool isLoading = false;

  void onLinkSend() async {
    if (_passwordController.text.isEmpty) {
      toastMsg("Please set your account password");
    } else if (!_isPasswordValid) {
      toastMsg("Password must be atleast 6 character's long");
    } else {
      setState(() {
        isLoading = true;
      });

      var response = await authController.resetPassword(
          widget.oobCode, _passwordController.text);

      if (response != null) {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        toastMsg("Password resetted for ${response['email']}");
      } else {
        setState(() {
          isLoading = false;
        });
        toastMsg("Server Timeout");
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
                        textField(size, _passwordController, "New Password",
                            (value) {
                          if (_passwordController.text.length < 6) {
                            setState(() {
                              _isPasswordValid = false;
                            });
                          } else {
                            setState(() {
                              _isPasswordValid = true;
                            });
                          }
                        }, true, false, !_isPasswordValid),
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
                                      "Send Link",
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
