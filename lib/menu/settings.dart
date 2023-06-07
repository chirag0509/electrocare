import 'package:electrocare/components/drawer.dart';
import 'package:electrocare/repository/models/userModel.dart';
import 'package:electrocare/user/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../repository/controller/colorController.dart';
import '../repository/database/handleUser.dart';
import '../user/profile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final color = ColorController.instance;
  final userController = Get.put(HandleUser());
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: color.tertiary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: color.black, size: w * 0.075),
        ),
        drawer: DrawerCom.instance.drawer,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: w * 0.06,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 15),
            Stack(children: [
              StreamBuilder<UserModel>(
                stream: userController.getUserDetails(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CircleAvatar(
                        radius: w * 0.15,
                        backgroundImage: NetworkImage(snapshot.data!.image),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CircleAvatar(
                        radius: w * 0.15,
                        backgroundColor: color.secondary,
                      ),
                    );
                  }
                },
              ),
              Positioned(
                  right: 20,
                  top: 8,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: color.white,
                    child: FirebaseAuth.instance.currentUser!.emailVerified
                        ? Icon(
                            Icons.verified,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.warning,
                            color: Colors.orange,
                          ),
                  )),
            ]),
            SizedBox(height: 30),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              width: w * 1,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1,
                            crossAxisCount: 2),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          String title = index == 0
                              ? "Profile"
                              : index == 1
                                  ? "Services"
                                  : "";

                          IconData icon = index == 0
                              ? Icons.person_outline
                              : index == 1
                                  ? Icons.receipt_outlined
                                  : Icons.not_accessible;

                          return InkWell(
                            onTap: () {
                              if (index == 0) {
                                Get.to(() => Profile());
                              } else if (index == 1) {
                                Get.to(() => Services());
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: color.secondary,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 40),
                                    child: Icon(
                                      icon,
                                      size: w * 0.15,
                                      color: color.tertiary,
                                    ),
                                  ),
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: w * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
