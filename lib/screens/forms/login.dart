import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/controllers/auth_controller.dart';
import 'package:electrocare/respository/controllers/user_controller.dart';
import 'package:electrocare/respository/models/user_model.dart';
import 'package:electrocare/screens/forms/forget_pass.dart';
import 'package:electrocare/screens/forms/phone.dart';
import 'package:electrocare/screens/forms/resigter.dart';
import 'package:electrocare/utils/common_widgets.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:electrocare/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = Get.put(AuthController());
  final userController = Get.put(UserController());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void onLogin() async {
    setState(() {
      _isLoading = true;
    });

    bool isSignedIn = await authController.signInWithEmail(
        _emailController.text.trim(), _passwordController.text);

    if (isSignedIn) {
      await userController
          .getUserDetails(_emailController.text.trim())
          .then((value) {
        if (value) {
          authController.isLoggedIn.value = true;
        }
        setState(() {
          _isLoading = false;
        });
      });
    } else {
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
                Positioned(
                  bottom: 30.h,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
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
                        SizedBox(height: 120.h),
                        heading("Sign-In"),
                        SizedBox(height: 40.h),
                        textField(size, _emailController, "Email", (value) {},
                            false, false, false),
                        textField(size, _passwordController, "Password",
                            (value) {}, true, false, false),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ForgetPass()),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 25.w),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forget Password?",
                                style: Constants.poppins(
                                  14.sp,
                                  FontWeight.w500,
                                  Constants.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),
                        GestureDetector(
                          onTap: () {
                            onLogin();
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
                                      "Login",
                                      style: Constants.poppins(16.sp,
                                          FontWeight.w500, Constants.white),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          "Or",
                          style: Constants.poppins(
                              14.sp, FontWeight.w400, Constants.black),
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Phone()),
                                );
                              },
                              child: circularIcon(FontAwesomeIcons.phone,
                                  Constants.blue, 20.sp),
                            ),
                            SizedBox(width: 18.w),
                            GestureDetector(
                              onTap: () async {
                                List<String> data =
                                    await authController.signInWithGoogle();

                                if (data[0] == "create") {
                                  List<String> parts = data[1].split("@");

                                  Map<String, dynamic> plan = {
                                    "name": "free",
                                    "pricePaid": 0,
                                    "serviceDiscount": 0,
                                    "repairDiscount": 0,
                                    "cashback": 0,
                                  };

                                  UserModel user = UserModel(
                                    firstName: parts[0],
                                    lastName: '',
                                    email: data[1],
                                    phone: '',
                                    password: "electrocare",
                                    image: '',
                                    address: '',
                                    balance: 0,
                                    plan: plan,
                                    upiId: '',
                                    isActive: true,
                                    createdAt: Timestamp.now(),
                                  );

                                  bool isUserCreated =
                                      await userController.createUser(user);

                                  if (isUserCreated) {
                                    await userController
                                        .getUserDetails(data[1])
                                        .then((value) {
                                      if (value) {
                                        authController.isLoggedIn.value = true;
                                      }
                                    });
                                  }
                                } else {
                                  await userController
                                      .getUserDetails(data[1])
                                      .then((value) {
                                    if (value) {
                                      authController.isLoggedIn.value = true;
                                    } else {
                                      toastMsg("No user found for that email!");
                                    }
                                  });
                                }
                              },
                              child: circularIcon(FontAwesomeIcons.google,
                                  Constants.red, 20.sp),
                            ),
                            SizedBox(width: 18.w),
                            GestureDetector(
                              onTap: () {
                                SharedPreferencesHelper.setIsLoginSkipped(true);
                                authController.isLoginSkipped.value = true;
                              },
                              child: circularIcon(
                                  Icons.forward, Constants.orange, 20.sp),
                            ),
                          ],
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
