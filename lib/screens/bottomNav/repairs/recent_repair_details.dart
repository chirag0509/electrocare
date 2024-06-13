// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/controllers/request_controller.dart';
import 'package:electrocare/respository/controllers/transaction_controller.dart';
import 'package:electrocare/respository/controllers/user_controller.dart';
import 'package:electrocare/respository/models/repair_request_model.dart';
import 'package:electrocare/respository/models/transaction_model.dart';
import 'package:electrocare/utils/common_widgets.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:electrocare/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RecentRepairDetails extends StatefulWidget {
  final RepairRequestModel repairRequest;
  const RecentRepairDetails({
    super.key,
    required this.repairRequest,
  });

  @override
  State<RecentRepairDetails> createState() => _RecentRepairDetailsState();
}

class _RecentRepairDetailsState extends State<RecentRepairDetails> {
  final transactionController = Get.put(TransactionController());
  final requestController = Get.put(RequestController());
  final userController = Get.put(UserController());

  bool isLoading = false;

  void _paymentSuccess(PaymentSuccessResponse response) async {
    final String successDescription =
        "payment for ${widget.repairRequest.requestedBrand} ${widget.repairRequest.requestedModel}";

    int amount = widget.repairRequest.repairCharge +
        widget.repairRequest.serviceCharge -
        (widget.repairRequest.repairCharge *
                widget.repairRequest.discounts["repairDiscount"] /
                100)
            .round() -
        (widget.repairRequest.serviceCharge *
                widget.repairRequest.discounts["serviceDiscount"] /
                100)
            .round();

    final transaction = TransactionModel(
      orderId: response.orderId!,
      description: successDescription,
      requestId: widget.repairRequest.id!,
      amount: amount,
      type: "debit",
      status: "success",
      userId: SharedPreferencesHelper.getUserId(),
      createdAt: Timestamp.now(),
    );

    await transactionController.addTransaction(transaction);
    await requestController.updateRequestStatus(widget.repairRequest.id!);

    if (widget.repairRequest.discounts["cashback"] > 0) {
      int cashback =
          (amount * widget.repairRequest.discounts["cashback"] / 100).round();

      String cashbackDesc =
          "${widget.repairRequest.discounts['cashback']}% cashback on $successDescription";

      final cashbackTransaction = TransactionModel(
        orderId: response.orderId!,
        description: cashbackDesc,
        requestId: widget.repairRequest.id!,
        amount: cashback,
        type: "credit",
        status: "success",
        userId: SharedPreferencesHelper.getUserId(),
        createdAt: Timestamp.now(),
      );

      await transactionController.addTransaction(cashbackTransaction);
      await transactionController
          .updateAmount(userController.balance.value + cashback);
    }
  }

  void _paymentFail(PaymentFailureResponse response) async {
    final String failedDescription =
        "payment failed for ${widget.repairRequest.requestedBrand} ${widget.repairRequest.requestedModel}";

    int amount = widget.repairRequest.repairCharge +
        widget.repairRequest.serviceCharge -
        (widget.repairRequest.repairCharge *
                widget.repairRequest.discounts["repairDiscount"] /
                100)
            .round() -
        (widget.repairRequest.serviceCharge *
                widget.repairRequest.discounts["serviceDiscount"] /
                100)
            .round();

    final transaction = TransactionModel(
      orderId: response.error!["metadata"]["order_id"],
      description: failedDescription,
      requestId: widget.repairRequest.id!,
      amount: amount,
      type: "debit",
      status: "failure",
      userId: SharedPreferencesHelper.getUserId(),
      createdAt: Timestamp.now(),
    );

    await transactionController.addTransaction(transaction);
  }

  void onPayment() async {
    List<String> parts = SharedPreferencesHelper.getEmail().split("@");

    String receiptId =
        "${parts[0]}_${(transactionController.transactions.length + 1)}";

    int amount = widget.repairRequest.repairCharge +
        widget.repairRequest.serviceCharge -
        (widget.repairRequest.repairCharge *
                widget.repairRequest.discounts["repairDiscount"] /
                100)
            .round() -
        (widget.repairRequest.serviceCharge *
                widget.repairRequest.discounts["serviceDiscount"] /
                100)
            .round();

    if (amount <= userController.balance.value) {
      final String successDescription =
          "payment for ${widget.repairRequest.requestedBrand} ${widget.repairRequest.requestedModel}";

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r)),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              content: _paymentDialog(
                amount,
                () async {
                  setState(() {
                    isLoading = true;
                  });
                  await transactionController
                      .updateAmount(userController.balance.value - amount);

                  final transaction = TransactionModel(
                    orderId: "",
                    description: successDescription,
                    requestId: widget.repairRequest.id!,
                    amount: amount,
                    type: "debit",
                    status: "success",
                    userId: SharedPreferencesHelper.getUserId(),
                    createdAt: Timestamp.now(),
                  );

                  await transactionController.addTransaction(transaction);

                  await requestController
                      .updateRequestStatus(widget.repairRequest.id!)
                      .then((value) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    setState(() {
                      isLoading = false;
                    });
                  });
                },
                () async {
                  setState(() {
                    isLoading = true;
                  });
                  await transactionController
                      .createOrder(
                    "payment for ${widget.repairRequest.requestedBrand} ${widget.repairRequest.requestedModel}",
                    amount,
                    receiptId,
                    _paymentSuccess,
                    _paymentFail,
                  )
                      .then((value) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                },
              ),
            );
          });
    } else {
      setState(() {
        isLoading = true;
      });
      await transactionController
          .createOrder(
        "payment for ${widget.repairRequest.requestedBrand} ${widget.repairRequest.requestedModel}",
        amount,
        receiptId,
        _paymentSuccess,
        _paymentFail,
      )
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.bg1,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 60.h,
            ),
            Row(
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
                  "${widget.repairRequest.deviceType.capitalize}",
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
            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "-----  ${formatDateDMY(widget.repairRequest.createdAt)}  -----",
                      style: Constants.poppins(
                        12.sp,
                        FontWeight.w500,
                        Constants.grey,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 15.h),
                      decoration: BoxDecoration(
                        color: Constants.white,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 60.w,
                            height: 60.w,
                            child: Image(
                              image: CachedNetworkImageProvider(
                                  widget.repairRequest.image),
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.repairRequest.requestedBrand.capitalize} ${widget.repairRequest.requestedModel.capitalize}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Constants.poppins(
                                    16.sp,
                                    FontWeight.w500,
                                    Constants.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "₹ ${widget.repairRequest.repairCharge + widget.repairRequest.serviceCharge}",
                                  style: Constants.poppins(
                                    13.sp,
                                    FontWeight.w500,
                                    Constants.blue,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "${widget.repairRequest.status.capitalize}",
                                  style: Constants.poppins(
                                    13.sp,
                                    FontWeight.w500,
                                    widget.repairRequest.status == "completed"
                                        ? Constants.green
                                        : widget.repairRequest.status ==
                                                "technician assigned"
                                            ? Constants.secondary
                                            : Constants.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    widget.repairRequest.status == "pending"
                        ? Container(
                            width: size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 15.h),
                            decoration: BoxDecoration(
                              color: Constants.white,
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Center(
                              child: Text(
                                "Technician will be assigned soon!",
                                style: Constants.poppins(
                                  14.sp,
                                  FontWeight.w500,
                                  Constants.black,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Text(
                                "-----  Technician Details  -----",
                                style: Constants.poppins(
                                  12.sp,
                                  FontWeight.w500,
                                  Constants.grey,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  color: Constants.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        width: 60.w,
                                        height: 60.w,
                                        color: Constants.bg1,
                                        child: Image(
                                          image: CachedNetworkImageProvider(
                                              widget.repairRequest
                                                  .technician["image"]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${widget.repairRequest.technician["firstName"].toString().capitalize} ${widget.repairRequest.technician["lastName"].toString().capitalize}",
                                            style: Constants.poppins(
                                              14.sp,
                                              FontWeight.w500,
                                              Constants.black,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                            "${widget.repairRequest.technician["email"]}",
                                            style: Constants.poppins(
                                              13.sp,
                                              FontWeight.w500,
                                              Constants.grey,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                            "+91 ${widget.repairRequest.technician["phone"]}",
                                            style: Constants.poppins(
                                              13.sp,
                                              FontWeight.w500,
                                              Constants.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "-----  Pricing Details  -----",
                      style: Constants.poppins(
                        12.sp,
                        FontWeight.w500,
                        Constants.grey,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      width: size.width,
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 15.h),
                      decoration: BoxDecoration(
                        color: Constants.white,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        children: [
                          ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            children: widget.repairRequest.requestedParts
                                .map((entry) {
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
                                  "₹ ${widget.repairRequest.repairCharge}",
                                  style: Constants.poppins(
                                    16.sp,
                                    FontWeight.w400,
                                    Constants.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.repairRequest.discounts["repairDiscount"] >
                              0)
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
                                    "- ₹ ${(widget.repairRequest.repairCharge * (widget.repairRequest.discounts["repairDiscount"] / 100)).round()}",
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
                                  "₹ ${widget.repairRequest.serviceCharge}",
                                  style: Constants.poppins(
                                    16.sp,
                                    FontWeight.w400,
                                    Constants.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget
                                  .repairRequest.discounts["serviceDiscount"] >
                              0)
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
                                    "- ₹ ${(widget.repairRequest.serviceCharge * (widget.repairRequest.discounts["serviceDiscount"] / 100)).round()}",
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
                                  "₹ ${widget.repairRequest.repairCharge + widget.repairRequest.serviceCharge - (widget.repairRequest.repairCharge * widget.repairRequest.discounts["repairDiscount"] / 100).round() - (widget.repairRequest.serviceCharge * widget.repairRequest.discounts["serviceDiscount"] / 100).round()}",
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
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            if (widget.repairRequest.status == "payment pending")
              GestureDetector(
                onTap: () {
                  onPayment();
                },
                child: Container(
                  width: size.width * 0.4,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                      color: Constants.black,
                      border: Border.all(width: 0),
                      borderRadius: BorderRadius.circular(50.r)),
                  child: Center(
                    child: isLoading
                        ? SpinKitThreeBounce(
                            size: 16.sp,
                            color: Constants.white,
                          )
                        : Text(
                            "Pay Now",
                            maxLines: 2,
                            style: Constants.poppins(
                              16.sp,
                              FontWeight.w500,
                              Constants.white,
                            ),
                          ),
                  ),
                ),
              ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentDialog(int amount, Function() onTap, Function() onSkip) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.7,
      height: size.height * 0.25,
      decoration: BoxDecoration(
        color: Constants.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pay From Wallet",
            style: Constants.poppins(
              18.sp,
              FontWeight.w500,
              Constants.black,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Center(
            child: Text(
              "₹ $amount",
              style: Constants.poppins(
                24.sp,
                FontWeight.w500,
                Constants.black,
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Center(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 13.h),
                width: size.width * 0.6,
                decoration: BoxDecoration(
                    color: Constants.primary,
                    borderRadius: BorderRadius.circular(50.r)),
                child: Center(
                  child: isLoading
                      ? SpinKitThreeBounce(
                          color: Constants.white,
                          size: 16.sp,
                        )
                      : Text(
                          "Pay",
                          style: Constants.poppins(
                              16.sp, FontWeight.w500, Constants.white),
                        ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Center(
            child: GestureDetector(
              onTap: onSkip,
              child: Text(
                "Skip?",
                style: Constants.poppins(
                  16.sp,
                  FontWeight.w500,
                  Constants.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
