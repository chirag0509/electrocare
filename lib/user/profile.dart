import 'package:electrocare/repository/authentication/auth.dart';
import 'package:electrocare/repository/database/handleUser.dart';
import 'package:electrocare/repository/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/controller/colorController.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final color = ColorController.instance;
  final _formKey = GlobalKey<FormState>();
  final userController = Get.put(HandleUser());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: color.tertiary,
          elevation: 0,
          iconTheme: IconThemeData(color: color.black, size: w * 0.075),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              ClipPath(
                clipper: HalfCircleClipper(),
                child: Container(
                  width: w,
                  height: w * 0.3,
                  color: color.tertiary,
                ),
              ),
              StreamBuilder<UserModel>(
                stream: userController.getUserDetails(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final address =
                        TextEditingController(text: snapshot.data!.address);
                    return Container(
                      width: w,
                      height: h * 0.89,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: CircleAvatar(
                                    radius: w * 0.17,
                                    backgroundImage:
                                        NetworkImage(snapshot.data!.image),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                    snapshot.data!.name.capitalize.toString(),
                                    style: TextStyle(
                                        fontSize: w * 0.08,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        snapshot.data!.email,
                                        style: TextStyle(
                                            fontSize: w * 0.045,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      FirebaseAuth.instance.currentUser!
                                              .emailVerified
                                          ? Icon(
                                              Icons.verified,
                                              color: Colors.green,
                                            )
                                          : ElevatedButton(
                                              onPressed: () async {
                                                await Auth.instance
                                                    .sendEmailVerification();
                                              },
                                              child: Text("Verify"))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        "+91 " + snapshot.data!.phone,
                                        style: TextStyle(
                                            fontSize: w * 0.045,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.verified,
                                        color: Colors.green,
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: TextFormField(
                                    controller: address,
                                    style: TextStyle(fontSize: w * 0.04),
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                        alignLabelWithHint: true,
                                        labelText: "Address",
                                        hintText: "Enter your current address",
                                        labelStyle:
                                            TextStyle(fontSize: w * 0.04),
                                        hintStyle:
                                            TextStyle(fontSize: w * 0.04),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 18),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your address';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: InkWell(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final user = UserModel(
                                        name: snapshot.data!.name,
                                        email: snapshot.data!.email,
                                        phone: snapshot.data!.phone,
                                        password: snapshot.data!.password,
                                        image: snapshot.data!.image,
                                        address: address.text);
                                    await userController.updateUser(user);
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
                                      "Submit",
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
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, -size.height * 5);
    path.arcToPoint(
      Offset(size.width, size.height / 2),
      radius: Radius.circular(size.width / 2),
      clockwise: false,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
