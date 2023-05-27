import 'package:electrocare/repository/controller/colorController.dart';
import 'package:electrocare/user/categories.dart';
import 'package:electrocare/user/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerCom extends GetxController {
  static DrawerCom get instance => Get.find();

  Drawer drawer = Drawer(
    backgroundColor: Colors.white,
    child: ListView(
      children: [
        DrawerHeader(
            child: Container(
          height: 100,
          width: 100,
          padding: EdgeInsets.all(5),
          child: Image.asset('assets/images/logo.png'),
        )),
        ListTile(
          onTap: () {
            Get.to(() => Dashboard());
          },
          horizontalTitleGap: 10,
          shape:
              Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300)),
          leading: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.dashboard_outlined,
              color: Color(0xfff2b29d),
            ),
          ),
          title: Text(
            "Dashboard",
            style: TextStyle(fontSize: 20),
          ),
        ),
        ListTile(
          onTap: () {
            Get.to(() => Categories());
          },
          horizontalTitleGap: 10,
          shape:
              Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300)),
          leading: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.category_outlined,
              color: Color(0xFFACC1FE),
            ),
          ),
          title: Text(
            "Categories",
            style: TextStyle(fontSize: 20),
          ),
        ),
        ListTile(
          horizontalTitleGap: 10,
          shape:
              Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300)),
          leading: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.settings_outlined,
              color: Color(0xFFd3d3d4),
            ),
          ),
          title: Text(
            "Settings",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    ),
  );
}
