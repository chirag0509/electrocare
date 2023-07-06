import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/menu/about.dart';
import 'package:electrocare/menu/settings.dart';
import 'package:electrocare/menu/terms.dart';
import 'package:electrocare/repository/authentication/auth.dart';
import 'package:electrocare/repository/controller/colorController.dart';
import 'package:electrocare/user/categories.dart';
import 'package:electrocare/user/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerCom extends GetxController {
  static DrawerCom get instance => Get.find();

  Drawer drawer = Drawer(
    backgroundColor: Colors.white,
    child: Column(
      children: [
        DrawerHeader(
            child: Container(
          height: 150,
          width: 150,
          padding: EdgeInsets.all(5),
          child: Image.asset('assets/images/logo.png'),
        )),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                onTap: () {
                  Get.to(() => Dashboard());
                },
                horizontalTitleGap: 10,
                shape: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey.shade300)),
                leading: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.dashboard_outlined,
                    color: Color.fromARGB(255, 242, 178, 157),
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
                shape: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey.shade300)),
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
                onTap: () {
                  Get.to(() => About());
                },
                horizontalTitleGap: 10,
                shape: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey.shade300)),
                leading: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.group_outlined,
                    color: Colors.orange,
                  ),
                ),
                title: Text(
                  "About Us",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.to(() => Terms());
                },
                horizontalTitleGap: 10,
                shape: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey.shade300)),
                leading: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.library_books_outlined,
                    color: Colors.blue,
                  ),
                ),
                title: Text(
                  "T&C",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.to(() => SettingsPage());
                },
                horizontalTitleGap: 10,
                shape: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey.shade300)),
                leading: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.settings_outlined,
                    color: Colors.grey.shade400,
                  ),
                ),
                title: Text(
                  "Settings",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.black,
          child: ListTile(
            onTap: () {
              Auth.instance.logout();
            },
            horizontalTitleGap: 15,
            contentPadding: EdgeInsets.symmetric(vertical: 5),
            leading: Padding(
              padding: EdgeInsets.only(left: 25),
              child: Icon(
                Icons.logout,
                color: Colors.red,
              ),
            ),
            title: Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}
