import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormController extends GetxController {
  static FormController get instance => Get.find();

  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmNewPassword = TextEditingController();
  final subject = TextEditingController();
  final message = TextEditingController();

  final emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

}
