// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/controllers/availability_controller.dart';
import 'package:electrocare/respository/controllers/request_controller.dart';
import 'package:electrocare/respository/controllers/user_controller.dart';
import 'package:electrocare/respository/models/availability_model.dart';
import 'package:electrocare/respository/models/repair_request_model.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:electrocare/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckAvailability extends StatefulWidget {
  final String category;
  final String categoryId;
  final String device;
  final String deviceId;
  final String brand;
  final String model;
  final String image;
  final List<String> selectParts;
  final int serviceCharge;
  const CheckAvailability({
    super.key,
    required this.category,
    required this.categoryId,
    required this.device,
    required this.deviceId,
    required this.brand,
    required this.model,
    required this.image,
    required this.selectParts,
    required this.serviceCharge,
  });

  @override
  State<CheckAvailability> createState() => _CheckAvailabilityState();
}

class _CheckAvailabilityState extends State<CheckAvailability> {
  final availabilityController = Get.put(AvailabilityController());
  final requestController = Get.put(RequestController());
  final userController = Get.put(UserController());

  List<Map<String, dynamic>> filteredParts = [];

  int total = 0;

  bool _isLoading = false;

  void initFilteredParts() {
    for (var e in widget.selectParts) {
      Map<String, dynamic> data = {
        "name": e,
        "price": 0,
        "availability": "not available"
      };
      filteredParts.add(data);
    }
  }

  void initPrefs() async {
    initFilteredParts();

    final response = await availabilityController.checkAvailability(
        widget.categoryId, widget.deviceId, widget.brand, widget.model);
    if (response == null) {
      final user = {
        "firstName": userController.firstName.value,
        "lastName": userController.lastName.value,
        "email": SharedPreferencesHelper.getEmail(),
        "phone": userController.phone.value,
        "address": userController.address.value,
        "image": userController.image.value,
      };

      final technician = {
        "firstName": "",
        "lastName": "",
        "email": "",
        "phone": "",
        "image": "",
      };

      final discounts = {
        "serviceDiscount": userController.plan['repairDiscount'],
        "repairDiscount": userController.plan['repairDiscount'],
        "cashback": userController.plan['cashback'],
      };

      final request = RepairRequestModel(
        requestedBrand: widget.brand,
        requestedModel: widget.model,
        deviceType: widget.device,
        category: widget.category,
        image: widget.image,
        requestedParts: filteredParts,
        user: user,
        technician: technician,
        status: "part not available",
        repairCharge: total,
        serviceCharge: widget.serviceCharge,
        discounts: discounts,
        createdAt: Timestamp.now(),
      );

      await requestController.addRequest(request);
    } else {
      setState(() {
        filteredParts = response.parts.where((part) {
          return widget.selectParts
              .any((selectedPart) => selectedPart == part["name"]);
        }).toList();

        filteredParts.sort((a, b) {
          return a["availability"].compareTo(b["availability"]);
        });

        total = 0;

        for (var element in filteredParts) {
          if (element["availability"] == "available") {
            total += int.parse(element['price'].toString());
          }
        }
      });
    }
  }

  void requestService(String image) async {
    setState(() {
      _isLoading = true;
    });
    final user = {
      "firstName": userController.firstName.value,
      "lastName": userController.lastName.value,
      "email": SharedPreferencesHelper.getEmail(),
      "phone": userController.phone.value,
      "address": userController.address.value,
      "image": userController.image.value,
    };

    final technician = {
      "firstName": "",
      "lastName": "",
      "email": "",
      "phone": "",
      "image": "",
    };

    final discounts = {
      "serviceDiscount": userController.plan['repairDiscount'],
      "repairDiscount": userController.plan['repairDiscount'],
      "cashback": userController.plan['cashback'],
    };

    final request = RepairRequestModel(
      requestedBrand: widget.brand,
      requestedModel: widget.model,
      deviceType: widget.device,
      category: widget.category,
      image: image,
      requestedParts: filteredParts,
      user: user,
      technician: technician,
      status: "pending",
      repairCharge: total,
      serviceCharge: widget.serviceCharge,
      discounts: discounts,
      createdAt: Timestamp.now(),
    );

    bool isSubmitted = await requestController.addRequest(request);

    if (isSubmitted) {
      setState(() {
        _isLoading = false;
      });
      Navigator.popUntil(context, (route) {
        return route.isFirst;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.bg1,
      body: availabilityController.availabilityModel == null
          ? const Center(
              child: Text("No Data Found"),
            )
          : Column(
              children: [
                SizedBox(
                  height: 60.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 21.r,
                          backgroundColor: Constants.white,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 21.sp,
                            color: Constants.black,
                          ),
                        ),
                      ),
                      Text(
                        "Pricing",
                        style: Constants.poppins(
                          20.sp,
                          FontWeight.w500,
                          Constants.black,
                        ),
                      ),
                      CircleAvatar(
                        radius: 21.r,
                        backgroundColor: Constants.white,
                        child: Icon(
                          FontAwesomeIcons.bell,
                          size: 21.sp,
                          color: Constants.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      width: size.width,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 20.h),
                      decoration: BoxDecoration(
                        color: Constants.white,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "${availabilityController.availabilityModel!.brand} ${availabilityController.availabilityModel!.model}"
                                .capitalize
                                .toString(),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: Constants.poppins(
                              18.sp,
                              FontWeight.w500,
                              Constants.black,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              children: filteredParts.map((entry) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 10.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "${entry["name"].toString().capitalize}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Constants.poppins(
                                            16.sp,
                                            FontWeight.w400,
                                            Constants.grey,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        entry["availability"] == "available"
                                            ? "₹ ${entry['price']}"
                                            : "${entry['availability'].toString().capitalize}",
                                        style: Constants.poppins(
                                          16.sp,
                                          FontWeight.w400,
                                          entry["availability"] == "available"
                                              ? Constants.grey
                                              : Constants.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Divider(
                            height: 10.h,
                            color: Constants.grey,
                            thickness: 0.5,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Repair Charge",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Constants.poppins(
                                      16.sp,
                                      FontWeight.w400,
                                      Constants.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  "₹ $total",
                                  style: Constants.poppins(
                                    16.sp,
                                    FontWeight.w400,
                                    Constants.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (userController.plan["repairDiscount"] > 0)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 10.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Discount On Repair",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Constants.poppins(
                                        16.sp,
                                        FontWeight.w400,
                                        Constants.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "- ₹ ${(total * (userController.plan['repairDiscount'] / 100)).round()}",
                                    style: Constants.poppins(
                                      16.sp,
                                      FontWeight.w400,
                                      Constants.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Service Charge",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Constants.poppins(
                                      16.sp,
                                      FontWeight.w400,
                                      Constants.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  "₹ ${widget.serviceCharge}",
                                  style: Constants.poppins(
                                    16.sp,
                                    FontWeight.w400,
                                    Constants.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (userController.plan["serviceDiscount"] > 0)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 10.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Discount On Service",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Constants.poppins(
                                        16.sp,
                                        FontWeight.w400,
                                        Constants.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "- ₹ ${(widget.serviceCharge * (userController.plan['serviceDiscount'] / 100)).round()}",
                                    style: Constants.poppins(
                                      16.sp,
                                      FontWeight.w400,
                                      Constants.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Total",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Constants.poppins(
                                      16.sp,
                                      FontWeight.w400,
                                      Constants.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  "₹ ${total + widget.serviceCharge - (total * (userController.plan['repairDiscount'] / 100)).round() - (widget.serviceCharge * (userController.plan['serviceDiscount'] / 100)).round()}",
                                  style: Constants.poppins(
                                    16.sp,
                                    FontWeight.w400,
                                    Constants.secondary,
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
                SizedBox(
                  height: 20.h,
                ),
                GestureDetector(
                  onTap: () {
                    requestService(
                        availabilityController.availabilityModel!.image);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                    decoration: BoxDecoration(
                        color: Constants.black,
                        border: Border.all(width: 0),
                        borderRadius: BorderRadius.circular(50.r)),
                    child: _isLoading
                        ? SizedBox(
                            width: size.width * 0.3,
                            child: SpinKitThreeBounce(
                              size: 16.sp,
                              color: Constants.white,
                            ),
                          )
                        : Text(
                            "Request Service",
                            maxLines: 2,
                            style: Constants.poppins(
                              16.sp,
                              FontWeight.w500,
                              Constants.white,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
    );
  }
}
