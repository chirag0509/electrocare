import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/animations/resetValidation.dart';
import 'package:electrocare/repository/authentication/auth.dart';
import 'package:electrocare/repository/controller/formController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

import '../repository/controller/colorController.dart';
import 'contact.dart';

class ForgetPsk extends StatefulWidget {
  const ForgetPsk({super.key});

  @override
  State<ForgetPsk> createState() => _ForgetPskState();
}

class _ForgetPskState extends State<ForgetPsk> {
  bool enableOtp = false;
  bool enablePsk = false;
  bool showPsk = false;

  final color = ColorController.instance;

  String? phone;

  final fi = FormController.instance;
  final _formKey = GlobalKey<FormState>();

  Future<void> checkUser() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(fi.email.text)
          .get();
      if (userDoc.exists) {
        phone = userDoc.data()!['phone'];
        await Auth.instance.phoneAuthentication(phone!);
        setState(() {
          enableOtp = true;
        });
      } else {
        Get.showSnackbar(GetSnackBar(
          message: "Account does not exists",
          duration: Duration(seconds: 2),
          backgroundColor: Colors.black,
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  int _counter = 59;
  late Timer _timer;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 1) {
        setState(() {
          _counter--;
        });
      } else {
        setState(() {
          _timer.cancel();
          _counter = 59;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    var otp;

    return SafeArea(
        child: Scaffold(
      backgroundColor: color.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: color.black,
                size: w * 0.08,
              )),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () {
                Get.to(() => Contact());
              },
              icon: Icon(
                Icons.support_agent,
                color: color.black,
                size: w * 0.1,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                          color: color.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: w * 0.1),
                    ),
                  ),
                ),
                enablePsk
                    ? Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              controller: fi.password,
                              style: TextStyle(fontSize: w * 0.045),
                              obscureText: !showPsk,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock_open_outlined),
                                  suffixIcon: showPsk
                                      ? IconButton(
                                          splashColor: Colors.transparent,
                                          onPressed: () {
                                            setState(() {
                                              showPsk = !showPsk;
                                            });
                                          },
                                          icon: Icon(
                                              Icons.visibility_off_outlined))
                                      : IconButton(
                                          splashColor: Colors.transparent,
                                          onPressed: () {
                                            setState(() {
                                              showPsk = !showPsk;
                                            });
                                          },
                                          icon:
                                              Icon(Icons.visibility_outlined)),
                                  labelText: "Password",
                                  hintText: "Enter a strong password",
                                  prefixStyle: TextStyle(fontSize: w * 0.045),
                                  labelStyle: TextStyle(fontSize: w * 0.045),
                                  hintStyle: TextStyle(fontSize: w * 0.045),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1),
                                      borderRadius: BorderRadius.circular(10))),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a password';
                                } else if (value.length < 6) {
                                  return 'Password must be atleast of 6 characters';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              controller: fi.confirmNewPassword,
                              style: TextStyle(fontSize: w * 0.045),
                              obscureText: !showPsk,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock_open_outlined),
                                  labelText: "Confirm Password",
                                  hintText: "Enter a same password as above",
                                  prefixStyle: TextStyle(fontSize: w * 0.045),
                                  labelStyle: TextStyle(fontSize: w * 0.045),
                                  hintStyle: TextStyle(fontSize: w * 0.045),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1),
                                      borderRadius: BorderRadius.circular(10))),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a password';
                                } else if (value.length < 6) {
                                  return 'Password must be atleast of 6 characters';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: enableOtp
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Enter the OTP sent to",
                                          style: TextStyle(
                                              fontSize: w * 0.06,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "xxxxxx" + phone!.substring(6, 10),
                                          style: TextStyle(
                                              fontSize: w * 0.06,
                                              fontWeight: FontWeight.bold,
                                              color: color.primary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  OtpTextField(
                                    numberOfFields: 6,
                                    filled: true,
                                    showFieldAsBox: true,
                                    fieldWidth: w * 0.11,
                                    onSubmit: (value) async {
                                      otp = value;
                                      final check = await Auth.instance
                                          .verifyOTP(otp, '', '',context);
                                      if (check) {
                                        setState(() {
                                          enableOtp = false;
                                          enablePsk = true;
                                          Auth.instance.isResettingPassword =
                                              true;
                                        });
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: _counter == 59
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Didn't recieve the OTP? ",
                                                style: TextStyle(
                                                    fontSize: w * 0.05,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  await Auth.instance
                                                      .phoneAuthentication(
                                                          phone!)
                                                      .then((value) =>
                                                          startTimer());
                                                },
                                                child: Text(
                                                  "Resend OTP",
                                                  style: TextStyle(
                                                      fontSize: w * 0.05,
                                                      color: color.primary,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            "00 : $_counter",
                                            style: TextStyle(
                                                fontSize: w * 0.05,
                                                fontWeight: FontWeight.w500),
                                          ),
                                  ),
                                ],
                              )
                            : TextFormField(
                                controller: fi.email,
                                style: TextStyle(fontSize: w * 0.045),
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined),
                                    labelText: "Email",
                                    hintText: "Enter your email",
                                    prefixStyle: TextStyle(fontSize: w * 0.045),
                                    labelStyle: TextStyle(fontSize: w * 0.045),
                                    hintStyle: TextStyle(fontSize: w * 0.045),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1),
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email';
                                  } else if (!RegExp(fi.emailRegex)
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                      ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (enableOtp) {
                          final check =
                              await Auth.instance.verifyOTP(otp, '', '',context);
                          if (check) {
                            setState(() {
                              enableOtp = false;
                              enablePsk = true;
                              Auth.instance.isResettingPassword = true;
                            });
                          }
                        } else if (enablePsk) {
                          if (fi.password.text == fi.confirmNewPassword.text) {
                            await FirebaseAuth.instance.currentUser!
                                .updatePassword(fi.password.text);
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.email)
                                .update({'password': fi.password.text});
                            Get.to(() => ResetValidation());
                          }
                        } else {
                          checkUser();
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: color.black,
                        borderRadius: BorderRadius.circular(w * 1),
                      ),
                      child: Center(
                        child: Text(
                          enableOtp
                              ? "Submit"
                              : enablePsk
                                  ? "Reset"
                                  : "Send OTP",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.07,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
                if (enableOtp)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have number? ",
                          style: TextStyle(
                              fontSize: w * 0.05, fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () async {
                            await Auth.instance
                                .sendPasswordResetEmail(fi.email.text);
                            setState(() {
                              Auth.instance.isResettingPassword = false;
                              Auth.instance.logout();
                            });
                          },
                          splashColor: Colors.transparent,
                          child: Text(
                            "Send Verification",
                            style: TextStyle(
                                color: color.primary,
                                fontSize: w * 0.05,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
