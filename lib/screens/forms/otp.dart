// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/main.dart';
import 'package:electrocare/respository/controllers/auth_controller.dart';
import 'package:electrocare/respository/controllers/user_controller.dart';
import 'package:electrocare/respository/models/user_model.dart';
import 'package:electrocare/utils/common_widgets.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:electrocare/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPScreen extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String phone;
  final String? password;
  final Map<String, dynamic>? plan;
  final bool isLogin;

  const OTPScreen({
    super.key,
    this.firstName,
    this.lastName,
    this.email,
    required this.phone,
    this.password,
    required this.isLogin,
    this.plan,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final authController = Get.put(AuthController());
  final userController = Get.put(UserController());

  final TextEditingController _otpController = TextEditingController();

  bool _isLoading = false;

  Timer? _timer;
  int _start = 59;
  bool _canResend = true;

  void startTimer() {
    setState(() {
      _canResend = false;
      _start = 59;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start < 2) {
          timer.cancel();
          _canResend = true;
        } else {
          _start--;
        }
      });
    });
  }

  void resendOTP() async {
    if (_canResend) {
      await authController.phoneAuthentication(widget.phone);
      startTimer();
    }
  }

  String _otp = '';

  void submitOTP() async {
    setState(() {
      _isLoading = true;
    });
    bool isOTPVerified = await authController.verifyOTP(
        otp: _otp,
        email: widget.email,
        password: widget.password,
        isLogin: widget.isLogin);

    if (isOTPVerified) {
      if (!widget.isLogin) {
        final user = UserModel(
          firstName: widget.firstName!,
          lastName: widget.lastName!,
          email: widget.email!,
          phone: widget.phone,
          password: widget.password!,
          image: "",
          address: '',
          balance: 0,
          plan: widget.plan!,
          upiId: '',
          isActive: true,
          createdAt: Timestamp.now(),
        );

        bool isUserCreated = await userController.createUser(user);

        if (isUserCreated) {
          await userController.getUserDetails(widget.email!).then((value) {
            if (value) {
              authController.isLoggedIn.value = true;
            }
          });

          Navigator.popUntil(context, (route) => route.isFirst);
        }
      } else {
        await userController
            .getUserDetailsUsingPhone(widget.phone)
            .then((value) {
          if (value) {
            authController.isLoggedIn.value = true;
          }
        });

        Navigator.popUntil(context, (route) => route.isFirst);
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      toastMsg("Invalid OTP");
      setState(() {
        _isLoading = false;
      });
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
                        SizedBox(height: 120.h),
                        SizedBox(
                            width: size.width * 0.6,
                            child: SvgPicture.asset(
                              "assets/otpMsgBox.svg",
                              fit: BoxFit.contain,
                            )),
                        SizedBox(height: 40.h),
                        Container(
                          width: size.width * 0.4,
                          height: 8.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 0),
                                  blurRadius: 22,
                                ),
                              ]),
                        ),
                        SizedBox(height: 50.h),
                        heading("OTP Verification"),
                        SizedBox(height: 5.h),
                        Text(
                          "Enter the OTP sent to +91 ${widget.phone}",
                          style: Constants.poppins(
                              14.sp, FontWeight.w500, Constants.grey),
                        ),
                        SizedBox(height: 40.h),
                        SizedBox(
                          height: 60.h,
                          child: PinFieldAutoFill(
                            autoFocus: false,
                            currentCode: _otpController.text,
                            codeLength: 6,
                            decoration: BoxLooseDecoration(
                              textStyle: Constants.poppins(
                                30.sp,
                                FontWeight.w500,
                                Constants.black,
                              ),
                              gapSpace: 16,
                              strokeColorBuilder: PinListenColorBuilder(
                                Constants.primary,
                                Colors.grey,
                              ),
                              bgColorBuilder: PinListenColorBuilder(
                                Colors.transparent,
                                Colors.transparent,
                              ),
                            ),
                            controller: _otpController,
                            onCodeChanged: (otp) async {
                              setState(() {
                                _otp = otp!;
                              });
                              if (_otp.length == 6 && !_isLoading) {
                                submitOTP();
                              }
                            },
                            onCodeSubmitted: (otp) async {
                              _otpController.text = otp;
                              setState(() {
                                _otp = otp;
                              });
                              if (_otp.length == 6 && !_isLoading) {
                                submitOTP();
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 25.h),
                        Text(
                          "Didn't Receive OTP?",
                          style: Constants.poppins(
                            14.sp,
                            FontWeight.w500,
                            Constants.grey,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        GestureDetector(
                          onTap: () {
                            resendOTP();
                          },
                          child: Text(
                            _canResend ? "Resend OTP?" : "00 : $_start",
                            style: Constants.poppins(
                              14.sp,
                              FontWeight.w500,
                              Constants.primary,
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),
                        GestureDetector(
                          onTap: () {
                            if (_otp.length == 6 && !_isLoading) {
                              submitOTP();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 13.h),
                            width: size.width * 0.6,
                            decoration: BoxDecoration(
                                color: Constants.primary,
                                borderRadius: BorderRadius.circular(50.r)),
                            child: Center(
                              child: _isLoading
                                  ? SpinKitThreeBounce(
                                      color: Constants.white,
                                      size: 16.sp,
                                    )
                                  : Text(
                                      "Verify OTP",
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
