import 'dart:async';
import 'package:electrocare/repository/authentication/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../repository/controller/colorController.dart';

class Otp extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String password;
  Otp(
      {Key? key,
      required this.name,
      required this.email,
      required this.phone,
      required this.password});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
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

  final color = ColorController.instance;

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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Image.asset(
                  "assets/images/otp.png",
                  width: w * 0.7,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "OTP Verification",
                  style: TextStyle(
                      fontSize: w * 0.07, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                    text: "Enter the OTP sent to ",
                    style: TextStyle(fontSize: w * 0.05),
                  ),
                  TextSpan(
                    text: "+91 ${widget.phone}",
                    style: TextStyle(
                        fontSize: w * 0.05, fontWeight: FontWeight.bold),
                  )
                ])),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: OtpTextField(
                  numberOfFields: 6,
                  filled: true,
                  showFieldAsBox: true,
                  fieldWidth: w * 0.11,
                  onSubmit: (value) async {
                    otp = value;
                    await Auth.instance
                        .verifyOTP(otp, widget.email, widget.password);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: _counter == 59
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't recieve the OTP? ",
                            style: TextStyle(
                                fontSize: w * 0.05,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () async {
                              await Auth.instance
                                  .phoneAuthentication(widget.phone)
                                  .then((value) => startTimer());
                            },
                            child: Text(
                              "Resend OTP",
                              style: TextStyle(
                                  fontSize: w * 0.05,
                                  color: color.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    : Text(
                        "00 : $_counter",
                        style: TextStyle(
                            fontSize: w * 0.05, fontWeight: FontWeight.bold),
                      ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.07,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
