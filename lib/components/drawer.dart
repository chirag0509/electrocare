import 'package:electrocare/user/categories.dart';
import 'package:electrocare/user/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerCom extends GetxController {
  static DrawerCom get instance => Get.find();

  Drawer drawer = Drawer(
    child: ListView(
      children: [
        ListTile(
          onTap: () {
            Get.to(() => Dashboard());
          },
          title: Text("Dashboard"),
        ),
        ListTile(
          onTap: () {
            Get.to(() => Categories());
          },
          title: Text("Categories"),
        ),
        ListTile(
          title: Text("Settings"),
        ),
      ],
    ),
  );
}
