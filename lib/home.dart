import 'package:electrocare/forms/login.dart';
import 'package:electrocare/forms/register.dart';
import 'package:electrocare/repository/controller/colorController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final color = ColorController.instance;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      backgroundColor: color.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: h * 0.22,
                ),
                Image.asset(
                  'assets/images/logo.jpg',
                  width: w * 0.65,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: h * 0.26,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => Register());
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
                              "Get Started",
                              style: TextStyle(
                                  color: color.white,
                                  fontSize: w * 0.07,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have and account? ",
                            style: TextStyle(
                                fontSize: w * 0.05,
                                fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => Login());
                            },
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Text(
                              "Sign In",
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
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
