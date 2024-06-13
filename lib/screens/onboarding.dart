import 'package:electrocare/respository/controllers/auth_controller.dart';
import 'package:electrocare/screens/forms/login.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:electrocare/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Onboarding extends StatelessWidget {
  Onboarding({super.key});

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.bg1,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: size.width,
              child: Image.asset(
                "assets/onboarding.png",
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SizedBox(
            width: size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 90.h,
                ),
                Text(
                  "DISCOVER NOW",
                  style: Constants.poppins(
                    22.sp,
                    FontWeight.w600,
                    Constants.primary,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "Find Your On-Demand\nService Worker",
                  textAlign: TextAlign.center,
                  style: Constants.poppins(
                    28.sp,
                    FontWeight.w600,
                    Constants.black,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "We provide better service for you with our\nOn-demand service app",
                  textAlign: TextAlign.center,
                  style: Constants.poppins(
                    14.sp,
                    FontWeight.w600,
                    Constants.grey,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 10.w),
                      width: size.width * 0.42,
                      decoration: BoxDecoration(
                          color: Constants.white,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              color: Constants.black.withOpacity(0.1),
                              offset: const Offset(4, 4),
                              blurRadius: 15,
                            )
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Constants.secondary,
                            size: 35.sp,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "100+",
                                style: Constants.poppins(
                                  22.sp,
                                  FontWeight.w600,
                                  Constants.primary,
                                ),
                              ),
                              Text(
                                "expert worker",
                                style: Constants.poppins(
                                  14.sp,
                                  FontWeight.w500,
                                  Constants.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 10.w),
                      width: size.width * 0.42,
                      decoration: BoxDecoration(
                          color: Constants.white,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              color: Constants.black.withOpacity(0.1),
                              offset: const Offset(-4, 4),
                              blurRadius: 15,
                            )
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: Constants.orange,
                            size: 35.sp,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "500+",
                                style: Constants.poppins(
                                  22.sp,
                                  FontWeight.w600,
                                  Constants.primary,
                                ),
                              ),
                              Text(
                                "user review",
                                style: Constants.poppins(
                                  14.sp,
                                  FontWeight.w500,
                                  Constants.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50.h,
            left: (size.width - 43.w) / 2,
            child: GestureDetector(
              onTap: () {
                SharedPreferencesHelper.setIsFirstTime(false);

                authController.isFirstTime.value = false;
              },
              child: ClipOval(
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  color: Constants.white,
                  child: Icon(
                    Icons.arrow_outward_sharp,
                    color: Constants.primary,
                    size: 35.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
