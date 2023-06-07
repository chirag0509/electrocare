import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/components/drawer.dart';
import 'package:electrocare/repository/controller/colorController.dart';
import 'package:electrocare/repository/database/handleMenu.dart';
import 'package:electrocare/repository/database/handleUser.dart';
import 'package:electrocare/repository/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserTerms extends StatefulWidget {
  const UserTerms({super.key});

  @override
  State<UserTerms> createState() => _UserTermsState();
}

class _UserTermsState extends State<UserTerms> {
  final color = ColorController.instance;

  final menuController = Get.put(HandleMenu());
  final userController = Get.put(HandleUser());

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Terms & Conditions",
                style:
                    TextStyle(fontSize: w * 0.06, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: menuController.getTerms(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(children: [
                              WidgetSpan(
                                  child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.label_important,
                                  size: w * 0.04,
                                  color: color.primary,
                                ),
                              )),
                              TextSpan(
                                  text: snapshot.data![index]['point'],
                                  style: TextStyle(
                                      color: color.black, fontSize: w * 0.035)),
                            ])),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      "Loading...",
                      textAlign: TextAlign.justify,
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  Text(
                    "I agree to the terms and conditions",
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: InkWell(
                onTap: () async {
                  if (isChecked) {
                    final userDoc = await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .get();
                    if (userDoc.exists) {
                      final name = userDoc.get('name');
                      final email = userDoc.get('email');
                      final phone = userDoc.get('phone');
                      final password = userDoc.get('password');
                      final address = userDoc.get('address');
                      final image = userDoc.get('image');
                      final user = UserModel(
                          name: name,
                          email: email,
                          phone: phone,
                          password: password,
                          image: image,
                          address: address,
                          terms: "accepted");
                      await userController.updateUser(user);
                    }
                  } else {
                    Get.showSnackbar(
                      GetSnackBar(
                        message: "Please agree our terms and conditions.",
                        duration: Duration(seconds: 2),
                        backgroundColor: color.black,
                      ),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: color.black,
                  ),
                  child: Center(
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.w500,
                          color: color.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
