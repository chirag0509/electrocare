import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/repository/controller/formController.dart';
import 'package:electrocare/repository/database/handleUser.dart';
import 'package:electrocare/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/userModel.dart';

class Auth extends GetxController {
  static Auth get instance => Get.find();

  bool checkEmail = false;

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;

  bool isResettingPassword = false;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.email)
        .get();
    if (user != null) {
      if (userDoc.exists) {
        if (!isResettingPassword) {
          Get.offAllNamed(UserRoutes.dashboard);
        }
      }
    } else {
      Get.offAllNamed(MyRoutes.home);
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  )),
            );
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.showSnackbar(
          GetSnackBar(
            message: "No user found for that email.",
            duration: Duration(seconds: 2),
            backgroundColor: Color.fromARGB(255, 35, 35, 35),
          ),
        );
      } else if (e.code == 'wrong-password') {
        Get.showSnackbar(
          GetSnackBar(
            message: "Please check the password you entered.",
            duration: Duration(seconds: 2),
            backgroundColor: Color.fromARGB(255, 35, 35, 35),
          ),
        );
      }
    }
  }

  Future<void> logout() async =>
      await _auth.signOut().then((_) => Get.toNamed(MyRoutes.home));

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth
        ..sendPasswordResetEmail(email: email);
      Get.showSnackbar(GetSnackBar(
        message: 'Request has been send. Please check your inbox',
        duration: Duration(seconds: 2),
        backgroundColor: Colors.black,
        icon: Icon(
          Icons.done,
          color: Colors.green,
          size: 20,
        ),
      ));
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: e.toString(),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.black,
      ));
    }
  }

  Future<void> phoneAuthentication(String phone) async {
    await _auth
      ..verifyPhoneNumber(
        phoneNumber: "+91" + phone,
        verificationCompleted: (credential) async {},
        codeSent: (verificationId, resendToken) {
          this.verificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId.value = verificationId;
        },
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number') {
            Get.snackbar('Error', 'The Provided Phone Number is not Valid');
          } else {
            Get.snackbar('Error', 'Something went wrong');
          }
        },
      );
  }

  Future<bool> verifyOTP(
      String otp, String email, String password, BuildContext context) async {
    try {
      final phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: this.verificationId.value, smsCode: otp);
      final userCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  )),
            );
          });
      if (email != '' && password != '') {
        final emailAuthCredential =
            EmailAuthProvider.credential(email: email, password: password);
        await userCredential.user!.linkWithCredential(emailAuthCredential);
        final fi = FormController.instance;
        final controller = Get.put(HandleUser());
        final user = UserModel(
            name: fi.name.text,
            email: fi.email.text,
            phone: fi.phone.text,
            password: fi.password.text,
            terms: "",
            address: "",
            image:
                "https://firebasestorage.googleapis.com/v0/b/electrocare0.appspot.com/o/avatar.png?alt=media&token=6b719599-6477-41f8-9bf5-e2e381253e0f");
        await controller.createUser(user);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        Get.showSnackbar(GetSnackBar(
          message: 'The provided OTP is invalid.',
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 25, 25, 25),
        ));
      }
      return false;
    }
  }

  Future<void> sendEmailVerification() async {
    await _auth
      ..currentUser!.sendEmailVerification();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final email = googleUser!.email;
      final signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        if (signInMethods.length == 1) {
          final userDoc = await FirebaseFirestore.instance
              .collection("users")
              .doc(email)
              .get();
          if (userDoc.exists) {
            showDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: CircularProgressIndicator(),
                        )),
                  );
                });
            final password = userDoc.get('password');
            final emailAuthCredential =
                EmailAuthProvider.credential(email: email, password: password);
            await _auth.signInWithCredential(emailAuthCredential);
            await _auth.currentUser!.linkWithCredential(credential);
          }
        } else {
          await _auth.signInWithCredential(credential);
          showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: CircularProgressIndicator(),
                      )),
                );
              });
        }
      } else {
        Get.showSnackbar(
          GetSnackBar(
            message: "Please use email that you have registered.",
            duration: Duration(seconds: 2),
            backgroundColor: Color.fromARGB(255, 35, 35, 35),
          ),
        );
      }
    } catch (e) {
      print(e);
      Get.showSnackbar(
        GetSnackBar(
          message: "Something went wrong.",
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 35, 35, 35),
        ),
      );
    }
  }
}
