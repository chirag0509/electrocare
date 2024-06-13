import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/controllers/auth_controller.dart';
import 'package:electrocare/respository/controllers/request_controller.dart';
import 'package:electrocare/respository/controllers/user_controller.dart';
import 'package:electrocare/screens/bottomNav/repairs/recent_repair_details.dart';
import 'package:electrocare/utils/common_widgets.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RecentRepairs extends StatefulWidget {
  const RecentRepairs({super.key});

  @override
  State<RecentRepairs> createState() => _RecentRepairsState();
}

class _RecentRepairsState extends State<RecentRepairs> {
  final authController = Get.put(AuthController());
  final userController = Get.put(UserController());
  final requestController = Get.put(RequestController());

  void _initPrefs() async {
    bool? isActive = await userController.getUserStatus();

    if (isActive != null && !isActive) {
      await authController.logout();
    }

    requestController.fetchAllRequests();
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: categoryHeading("Recent Repairs"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Obx(
          () => requestController.requests.isEmpty
              ? const Center(
                  child: Text("No data found"),
                )
              : ListView.separated(
                  padding: EdgeInsets.only(top: 20.h, bottom: 50.h),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: requestController.requests.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10.h,
                    );
                  },
                  itemBuilder: (context, index) {
                    final data = requestController.requests[index];

                    return Container(
                      width: size.width,
                      padding: EdgeInsets.symmetric(
                          vertical: 15.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: Constants.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40.w,
                            width: 40.w,
                            child: Image(
                              image: CachedNetworkImageProvider(data.image),
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "${data.requestedBrand.capitalize} ${data.requestedModel.capitalize}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Constants.poppins(
                                          16.sp,
                                          FontWeight.w500,
                                          Constants.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      formatDateDMY(data.createdAt),
                                      style: Constants.poppins(
                                        11.sp,
                                        FontWeight.w500,
                                        Constants.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "₹ ${data.repairCharge + data.serviceCharge}",
                                      style: Constants.poppins(
                                        13.sp,
                                        FontWeight.w500,
                                        Constants.blue,
                                      ),
                                    ),
                                    Text(
                                      "${data.status.capitalize}",
                                      style: Constants.poppins(
                                        13.sp,
                                        FontWeight.w500,
                                        data.status == "completed"
                                            ? Constants.green
                                            : data.status ==
                                                    "technician assigned"
                                                ? Constants.secondary
                                                : Constants.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  "Total parts to be repaired : ${data.requestedParts.length}",
                                  style: Constants.poppins(
                                    13.sp,
                                    FontWeight.w500,
                                    Constants.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RecentRepairDetails(
                                                  repairRequest: data)),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 16.w),
                                    decoration: BoxDecoration(
                                        color: Constants.bg1,
                                        borderRadius:
                                            BorderRadius.circular(8.r)),
                                    child: Text(
                                      "View Details",
                                      style: Constants.poppins(
                                        13.sp,
                                        FontWeight.w500,
                                        Constants.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
