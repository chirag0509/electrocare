import 'package:cached_network_image/cached_network_image.dart';
import 'package:electrocare/main.dart';
import 'package:electrocare/respository/controllers/auth_controller.dart';
import 'package:electrocare/respository/controllers/user_controller.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:electrocare/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authController = Get.put(AuthController());
  final userController = Get.put(UserController());

  void _initPrefs() async {
    bool? isActive = await userController.getUserStatus();

    if (isActive != null && !isActive) {
      await authController.logout();
    }
  }

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.bg1,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(
                height: 100.h,
              ),
              Center(
                child: Obx(
                  () => userController.image.isEmpty
                      ? CircleAvatar(
                          radius: size.width * 0.125,
                          backgroundColor: Constants.white,
                          child: SvgPicture.asset(
                            "assets/avatar.svg",
                            width: size.width * 0.125,
                          ),
                        )
                      : ClipOval(
                          child: Container(
                            width: size.width * 0.25,
                            height: size.width * 0.25,
                            color: Constants.white,
                            child: Image(
                              image: CachedNetworkImageProvider(
                                  userController.image.value),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Center(
                child: Obx(
                  () => Text(
                    "${userController.firstName.value.capitalize} ${userController.lastName.value.capitalize}",
                    style: Constants.poppins(
                      24.sp,
                      FontWeight.w500,
                      Constants.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Center(
                child: Text(
                  SharedPreferencesHelper.getEmail(),
                  style: Constants.poppins(
                    14.sp,
                    FontWeight.w500,
                    Constants.black,
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                width: size.width,
                decoration: BoxDecoration(
                  color: Constants.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _rowBuilder("My Profile", FontAwesomeIcons.user, () {}),
                    _rowBuilder(
                        "Recent Repairs", FontAwesomeIcons.history, () {}),
                    _rowBuilder("Transactions", Icons.receipt_outlined, () {}),
                    _rowBuilder(
                        "Subscription", Icons.subscriptions_outlined, () {}),
                    _rowBuilder(
                        "Help & Support", Icons.help_outline_rounded, () {}),
                    _rowBuilder("Share App", Icons.share_outlined, () {}),
                    _rowBuilder(
                        "Privacy Policy", Icons.privacy_tip_outlined, () {}),
                    _rowBuilder("Delete Account", Icons.delete_outline, () {}),
                    _rowBuilder("Logout", Icons.logout_outlined, () async {
                      if (SharedPreferencesHelper.getIsLoggedIn()) {
                        await authController.logout();
                      } else {
                        authController.isLoginSkipped.value = false;
                      }
                    }),
                  ],
                ),
              ),
              SizedBox(
                height: 50.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _rowBuilder(String text, IconData icon, Function() ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: Constants.primary.withOpacity(0.1),
              child: Icon(
                icon,
                size: 18.sp,
                color: Constants.primary,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Text(
              text,
              style: Constants.poppins(
                16.sp,
                FontWeight.w500,
                Constants.black,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18.sp,
              color: Constants.grey,
            ),
          ],
        ),
      ),
    );
  }
}
