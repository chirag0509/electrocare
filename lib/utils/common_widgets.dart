import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

void toastMsg(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Constants.black,
    textColor: Constants.white,
    fontSize: 14.sp,
  );
}

Widget textField(
    Size size,
    TextEditingController controller,
    String text,
    void Function(String value) onChange,
    bool isPassword,
    bool isPhone,
    bool isError) {
  return SizedBox(
    width: size.width * 0.8,
    child: Column(
      children: [
        label(" $text"),
        SizedBox(
          height: 5.h,
        ),
        TextField(
          controller: controller,
          cursorColor: Constants.primary,
          decoration: InputDecoration(
            hintText: text,
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
                color: isError ? Constants.red : Constants.primary,
              ),
              borderRadius: BorderRadius.circular(15.r),
            ),
          ),
          onChanged: onChange,
          obscureText: isPassword ? true : false,
          keyboardType: isPhone ? TextInputType.number : TextInputType.text,
          inputFormatters: isPhone
              ? [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : [],
        ),
        SizedBox(
          height: 15.h,
        ),
      ],
    ),
  );
}

Widget label(String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: Constants.poppins(
        14.sp,
        FontWeight.w500,
        Constants.black,
      ),
    ),
  );
}

Widget heading(String text) {
  return Text(
    text,
    style: Constants.poppins(
      24.sp,
      FontWeight.w600,
      Constants.primary,
    ),
  );
}

Widget categoryHeading(String text) {
  return Text(
    text,
    style: Constants.poppins(
      20.sp,
      FontWeight.w600,
      Constants.black,
    ),
  );
}

Widget circularIcon(IconData icon, Color color, double size) {
  return Container(
    padding: EdgeInsets.all(13.w),
    decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Constants.grey,
        ),
        borderRadius: BorderRadius.circular(50.r)),
    child: Center(
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    ),
  );
}

String formattedDate(String date) {
  DateTime validityDate = DateTime.parse(date);

  String formattedDate = DateFormat('d MMMM h:mm a').format(validityDate);

  return formattedDate;
}

String formatDateDMY(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  String formattedDate = DateFormat('d MMMM y').format(dateTime);

  return formattedDate;
}

String formatTime(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  String formattedTime = DateFormat('hh:mm a').format(dateTime);

  return formattedTime;
}

String formatNumber(int number) {
  final formatter = NumberFormat("#,##,##0", "en_IN");
  return formatter.format(number);
}
