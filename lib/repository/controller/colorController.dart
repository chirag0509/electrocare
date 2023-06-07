import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorController extends GetxController {
  static ColorController get instance => Get.find();

  Color white = Colors.white;
  Color black = Color(0xFF1B1B1B);
  Color primary = Color(0xFF5F79FF);
  Color secondary = Color.fromARGB(255, 237, 240, 255);
  Color tertiary = Color(0xFFACC1FE);
}
