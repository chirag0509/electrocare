// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/controllers/auth_controller.dart';
import 'package:electrocare/screens/forms/login.dart';
import 'package:electrocare/screens/forms/otp.dart';
import 'package:electrocare/utils/common_widgets.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:field_validation/Source_Code/FlutterValidation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final authController = Get.put(AuthController());

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FlutterValidation validator = FlutterValidation();

  bool _isFirstNameValid = true;
  bool _isLastNameValid = true;
  bool _isEmailValid = true;
  bool _isPhoneValid = true;
  bool _isPasswordValid = true;

  bool _isLoading = false;

  void sendCode() async {
    setState(() {
      _isLoading = true;
    });
    if (_isEmailValid) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("users")
          .where("email", isEqualTo: _emailController.text.trim())
          .get();

      if (snapshot.docs.isEmpty) {
        QuerySnapshot<Map<String, dynamic>> phoneSnapShot =
            await FirebaseFirestore.instance
                .collection("users")
                .where("phone", isEqualTo: _phoneController.text.trim())
                .get();

        if (phoneSnapShot.docs.isNotEmpty) {
          setState(() {
            _isLoading = false;
          });
          toastMsg("Phone already registered");
          return;
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        toastMsg("Email already registered");
        return;
      }
    }

    if (_firstNameController.text.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      toastMsg("Please enter your first name");
    } else if (!_isFirstNameValid) {
      setState(() {
        _isLoading = false;
      });
      toastMsg("Please enter your valid first name");
    } else if (_lastNameController.text.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      toastMsg("Please enter your first name");
    } else if (!_isLastNameValid) {
      setState(() {
        _isLoading = false;
      });
      toastMsg("Please enter your valid first name");
    } else if (_emailController.text.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      toastMsg("Please enter your email address");
    } else if (!_isEmailValid) {
      setState(() {
        _isLoading = false;
      });
      toastMsg("Please enter your valid email address");
    } else if (_phoneController.text.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      toastMsg("Please enter your phone number");
    } else if (!_isPhoneValid) {
      setState(() {
        _isLoading = false;
      });
      toastMsg("Please enter your valid phone number");
    } else if (_passwordController.text.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      toastMsg("Please set your account password");
    } else if (!_isPasswordValid) {
      setState(() {
        _isLoading = false;
      });
      toastMsg("Password must be atleast 6 character's long");
    } else {
      setState(() {
        _isLoading = false;
      });
      await authController.phoneAuthentication(_phoneController.text.trim());

      Map<String, dynamic> plan = {
        "name": "free",
        "pricePaid": 0,
        "serviceDiscount": 0,
        "repairDiscount": 0,
        "cashback": 0,
      };

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OTPScreen(
                  firstName: _firstNameController.text.trim(),
                  lastName: _lastNameController.text.trim(),
                  email: _emailController.text.trim(),
                  phone: _phoneController.text.trim(),
                  password: _passwordController.text,
                  plan: plan,
                  isLogin: false,
                )),
      );
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
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
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
                          "Sign-In",
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
                        SizedBox(height: 120.h),
                        heading("Sign-Up"),
                        SizedBox(height: 40.h),
                        textField(size, _firstNameController, "First Name",
                            (value) {
                          setState(() {
                            if (_firstNameController.text.length < 3) {
                              _isFirstNameValid = false;
                            } else {
                              _isFirstNameValid = true;
                            }
                          });
                        }, false, false, !_isFirstNameValid),
                        textField(size, _lastNameController, "Last Name",
                            (value) {
                          setState(() {
                            if (_lastNameController.text.length < 3) {
                              _isLastNameValid = false;
                            } else {
                              _isLastNameValid = true;
                            }
                          });
                        }, false, false, !_isLastNameValid),
                        textField(size, _emailController, "Email", (value) {
                          setState(() {
                            _isEmailValid = validator.emailValidate(
                                content: _emailController.text);
                          });
                        }, false, false, !_isEmailValid),
                        textField(size, _phoneController, "Phone", (value) {
                          setState(() {
                            _isPhoneValid = validator.mobileValidate(
                                content: _phoneController.text);
                          });
                        }, false, true, !_isPhoneValid),
                        textField(size, _passwordController, "Password",
                            (value) {
                          setState(() {
                            if (_passwordController.text.length < 6) {
                              _isPasswordValid = false;
                            } else {
                              _isPasswordValid = true;
                            }
                          });
                        }, true, false, !_isPasswordValid),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () {
                            sendCode();
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
                                      "Register",
                                      style: Constants.poppins(
                                        16.sp,
                                        FontWeight.w500,
                                        Constants.white,
                                      ),
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
