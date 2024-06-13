// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/controllers/auth_controller.dart';
import 'package:electrocare/respository/controllers/transaction_controller.dart';
import 'package:electrocare/respository/controllers/user_controller.dart';
import 'package:electrocare/respository/models/transaction_model.dart';
import 'package:electrocare/utils/common_widgets.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:electrocare/utils/shared_pref_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final transactionController = Get.put(TransactionController());
  final userController = Get.put(UserController());
  final authController = Get.put(AuthController());

  int amount = 0;

  bool isLoading = false;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();

  final List<int> _amounts = [100, 500, 1000, 5000];

  String successDescription = "amount credited in wallet";
  String failedDescription = "failed to credit amount in wallet";
  String debitDescription = "amount debited";

  void _creditPaymentSuccess(PaymentSuccessResponse response) async {
    await transactionController
        .updateAmount(userController.balance.value + amount);

    final transaction = TransactionModel(
      orderId: response.orderId!,
      description: successDescription,
      requestId: "",
      amount: amount,
      type: "credit",
      status: "success",
      userId: SharedPreferencesHelper.getUserId(),
      createdAt: Timestamp.now(),
    );

    await transactionController.addTransaction(transaction);

    await userController.getUserDetails(SharedPreferencesHelper.getEmail());
    transactionController.fetchAllTransactions();
  }

  void _creditPaymentFail(PaymentFailureResponse response) async {
    final transaction = TransactionModel(
      orderId: response.error!["metadata"]["order_id"],
      description: failedDescription,
      requestId: "",
      amount: amount,
      type: "credit",
      status: "failure",
      userId: SharedPreferencesHelper.getUserId(),
      createdAt: Timestamp.now(),
    );

    await transactionController.addTransaction(transaction);
    transactionController.fetchAllTransactions();
  }

  Future<void> _debitAmount() async {
    try {
      await transactionController
          .updateAmount(userController.balance.value - amount);

      final transaction = TransactionModel(
        orderId: "",
        description: debitDescription,
        requestId: "",
        amount: amount,
        type: "debit",
        status: "processing",
        userId: SharedPreferencesHelper.getUserId(),
        createdAt: Timestamp.now(),
      );

      await transactionController.addTransaction(transaction);
      await userController.getUserDetails(SharedPreferencesHelper.getEmail());
      transactionController.fetchAllTransactions();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _initPrefs() async {
    bool? isActive = await userController.getUserStatus();

    if (isActive != null && !isActive) {
      await authController.logout();
    }

    userController.getUserDetails(SharedPreferencesHelper.getEmail());
    transactionController.fetchAllTransactions();
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
          title: categoryHeading("Wallet"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                    width: size.width,
                    decoration: BoxDecoration(
                        color: Constants.primary,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                          )
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => Text(
                                "₹ ${formatNumber(userController.balance.value)}",
                                style: Constants.poppins(
                                  35.sp,
                                  FontWeight.w500,
                                  Constants.white,
                                ),
                              ),
                            ),
                            Icon(
                              FontAwesomeIcons.wallet,
                              color: Constants.white,
                              size: 35.sp,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "Total Balance",
                          style: Constants.poppins(
                            14.sp,
                            FontWeight.w400,
                            Constants.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10.h,
                    right: 20.w,
                    child: Obx(
                      () => Text(
                        userController.upiId.value,
                        style: Constants.poppins(
                          14.sp,
                          FontWeight.w400,
                          Constants.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return AlertDialog(
                                insetPadding: EdgeInsets.zero,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 20.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r)),
                                content: _walletDialog("Deposit", () async {
                                  if (_amountController.text.isEmpty) {
                                    toastMsg("Please enter amount to deposit");
                                  } else if (int.parse(_amountController.text) <
                                      100) {
                                    toastMsg(
                                        "Please enter amount greater than 100");
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    List<String> parts =
                                        SharedPreferencesHelper.getEmail()
                                            .split("@");

                                    String receiptId =
                                        "${parts[0]}_${(transactionController.transactions.length + 1)}";

                                    await transactionController
                                        .createOrder(
                                      "add amount to wallet",
                                      int.parse(_amountController.text),
                                      receiptId,
                                      _creditPaymentSuccess,
                                      _creditPaymentFail,
                                    )
                                        .then((value) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.pop(context);
                                      _amountController.clear();
                                    });
                                  }
                                }),
                              );
                            });
                      },
                      child: Container(
                        padding: EdgeInsets.all(25.w),
                        decoration: BoxDecoration(
                            color: Constants.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              )
                            ]),
                        child: Icon(
                          FontAwesomeIcons.arrowUpFromBracket,
                          size: 25.sp,
                          color: Constants.blue,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return AlertDialog(
                                insetPadding: EdgeInsets.zero,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 20.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r)),
                                content: _walletDialog("Withdraw", () async {
                                  if (_amountController.text.isEmpty) {
                                    toastMsg("Please enter amount to deposit");
                                  } else if (int.parse(_amountController.text) <
                                      100) {
                                    toastMsg(
                                        "Please enter amount greater than 100");
                                  } else if (userController
                                      .upiId.value.isEmpty) {
                                    toastMsg(
                                        'Please add UPI ID to withdraw money');
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    await _debitAmount().then((value) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.pop(context);
                                      _amountController.clear();
                                    });
                                  }
                                }),
                              );
                            });
                      },
                      child: Container(
                        padding: EdgeInsets.all(25.w),
                        decoration: BoxDecoration(
                            color: Constants.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              )
                            ]),
                        child: Transform.rotate(
                          angle: 3.14,
                          child: Icon(
                            FontAwesomeIcons.arrowUpFromBracket,
                            size: 25.sp,
                            color: Constants.green,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _upiController.text = userController.upiId.value;
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return AlertDialog(
                                  insetPadding: EdgeInsets.zero,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 20.h),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.r)),
                                  content: _upiDialog(),
                                );
                              });
                        },
                        child: Container(
                          padding: EdgeInsets.all(25.w),
                          decoration: BoxDecoration(
                              color: Constants.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                )
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 35.w,
                                child: Image.asset(
                                  "assets/upi.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "Add UPI ID",
                                style: Constants.poppins(
                                  14.sp,
                                  FontWeight.w500,
                                  Constants.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              categoryHeading("Transactions"),
              SizedBox(
                height: 15.h,
              ),
              Obx(
                () => Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    decoration: BoxDecoration(
                      color: Constants.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r),
                      ),
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.only(bottom: 30.h),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: transactionController.transactions.length,
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Constants.grey,
                          thickness: 0.5,
                        );
                      },
                      itemBuilder: (context, index) {
                        final data = transactionController.transactions[index];

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: data.status == "failure"
                                    ? Constants.red.withOpacity(0.1)
                                    : data.type == "credit"
                                        ? Constants.green.withOpacity(0.1)
                                        : Constants.blue.withOpacity(0.1),
                                child: Transform.rotate(
                                  angle: data.type == "credit" ? 0 : 3.14,
                                  child: Icon(
                                    Icons.arrow_outward_rounded,
                                    size: 24.sp,
                                    color: data.status == "failure"
                                        ? Constants.red
                                        : data.type == "credit"
                                            ? Constants.green
                                            : Constants.blue,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${data.description.capitalize}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Constants.poppins(
                                        14.sp,
                                        FontWeight.w500,
                                        Constants.black,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "₹ ${data.amount}",
                                          style: Constants.poppins(
                                            13.sp,
                                            FontWeight.w500,
                                            Constants.grey,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.w),
                                          child: Text(
                                            "|",
                                            style: Constants.poppins(
                                              13.sp,
                                              FontWeight.w500,
                                              Constants.grey,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${data.status.capitalize}",
                                          style: Constants.poppins(
                                            13.sp,
                                            FontWeight.w500,
                                            data.status == "failure"
                                                ? Constants.red
                                                : data.type == "credit"
                                                    ? Constants.green
                                                    : Constants.blue,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formatDateDMY(data.createdAt),
                                    style: Constants.poppins(
                                      11.sp,
                                      FontWeight.w500,
                                      Constants.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    formatTime(data.createdAt),
                                    style: Constants.poppins(
                                      11.sp,
                                      FontWeight.w500,
                                      Constants.grey,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _walletDialog(String text, Function() onTap) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.3,
      width: size.width * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Amount",
            style: Constants.poppins(
              18.sp,
              FontWeight.w500,
              Constants.black,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Wrap(
            spacing: 10.w,
            direction: Axis.horizontal,
            children: List.generate(_amounts.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _amountController.text = _amounts[index].toString();

                    amount = _amounts[index];
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Constants.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    "${_amounts[index]}",
                    style: Constants.poppins(
                      13.sp,
                      FontWeight.w500,
                      Constants.grey,
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(
            height: 15.h,
          ),
          TextField(
            controller: _amountController,
            cursorColor: Constants.primary,
            decoration: InputDecoration(
              hintText: "Enter amount",
              hintStyle:
                  Constants.poppins(14.sp, FontWeight.w400, Constants.grey),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Constants.grey,
                ),
                borderRadius: BorderRadius.circular(15.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Constants.primary,
                ),
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(5),
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              setState(() {
                amount = int.parse(value);
              });
            },
          ),
          SizedBox(
            height: 15.h,
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
                          text,
                          style: Constants.poppins(
                              16.sp, FontWeight.w500, Constants.white),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _upiDialog() {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.25,
      width: size.width * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter UPI ID",
            style: Constants.poppins(
              18.sp,
              FontWeight.w500,
              Constants.black,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          TextField(
            controller: _upiController,
            cursorColor: Constants.primary,
            decoration: InputDecoration(
              hintText: "Enter UPI ID",
              hintStyle:
                  Constants.poppins(14.sp, FontWeight.w400, Constants.grey),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Constants.grey,
                ),
                borderRadius: BorderRadius.circular(15.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Constants.primary,
                ),
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            keyboardType: TextInputType.text,
          ),
          SizedBox(
            height: 15.h,
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                if (_upiController.text.isEmpty) {
                  toastMsg("Please enter your upi id");
                } else if (!_upiController.text.contains("@")) {
                  toastMsg("Please enter valid upi id");
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  await userController
                      .addUpi(_upiController.text.trim())
                      .then((value) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                  await userController
                      .getUserDetails(SharedPreferencesHelper.getEmail());
                  Navigator.pop(context);
                  _upiController.clear();
                }
              },
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
                          "Add UPI ID",
                          style: Constants.poppins(
                              16.sp, FontWeight.w500, Constants.white),
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
