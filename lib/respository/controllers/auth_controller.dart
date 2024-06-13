import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:electrocare/respository/controllers/user_controller.dart';
import 'package:electrocare/screens/forms/login.dart';
import 'package:electrocare/utils/common_widgets.dart';
import 'package:electrocare/utils/shared_pref_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> user;

  RxString verificationId = ''.obs;

  RxBool isFirstTime = SharedPreferencesHelper.getIsFirstTime().obs;
  RxBool isLoggedIn = SharedPreferencesHelper.getIsLoggedIn().obs;
  RxBool isLoginSkipped = SharedPreferencesHelper.getIsLoginSkipped().obs;

  Dio dio = Dio();

  static String resetPassUrl =
      "https://www.googleapis.com/identitytoolkit/v3/relyingparty/resetPassword?key=AIzaSyAwaR2ByKqCsU4c9wKw-WOQXG06MxSOa5A";

  @override
  void onInit() {
    super.onInit();
    user = Rx<User?>(_auth.currentUser);
  }

  //---------------------------------------- send otp ----------------------------------------//

  Future<void> phoneAuthentication(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91$phone",
      verificationCompleted: (phoneAuthCredential) {
        if (kDebugMode) {
          print("phoneAuthCredential: $phoneAuthCredential");
        }
      },
      verificationFailed: (error) {
        if (kDebugMode) {
          print("error: $error");
        }
        if (error.code == 'invalid-phone-number') {
          toastMsg('The Provided Phone Number is not Valid');
        } else {
          toastMsg('Sorry, Something went wrong!');
        }
      },
      codeSent: (verificationId, forceResendingToken) {
        if (kDebugMode) {
          print("code sent");
        }
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        if (kDebugMode) {
          print("codeAutoRetrievalTimeout");
        }
        this.verificationId.value = verificationId;
      },
    );
  }

  //---------------------------------------- verify otp ----------------------------------------//

  Future<bool> verifyOTP(
      {required String otp,
      String? email,
      String? password,
      required bool isLogin}) async {
    try {
      final phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId.value, smsCode: otp);

      final userCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (!isLogin) {
        final credential =
            EmailAuthProvider.credential(email: email!, password: password!);

        await userCredential.user!.linkWithCredential(credential);
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  //---------------------------------------- logout ----------------------------------------//

  Future<void> logout() async {
    try {
      await _auth.signOut().then((value) {
        SharedPreferencesHelper.clearShareCache();
        SharedPreferencesHelper.setIsFirstTime(false);
        SharedPreferencesHelper.setIsLoggedIn(false);

        isLoggedIn.value = false;
        Get.delete<UserController>();
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //---------------------------------------- sign in with email & password ----------------------------------------//

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("e.code ${e.code}");
      }

      if (e.code == 'invalid-credential') {
        toastMsg('Please check your entered email & password');
      } else if (e.code == 'too-many-requests') {
        toastMsg(e.message.toString());
      }
      return false;
    }
  }

  //---------------------------------------- google sign in ----------------------------------------//

  Future<List<String>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final email = googleUser.email;

      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final password = userDoc.docs.first.data()["password"];

        final emailAuthCredential =
            EmailAuthProvider.credential(email: email, password: password);

        await _auth.signInWithCredential(emailAuthCredential);

        try {
          await _auth.currentUser!.linkWithCredential(credential);
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }

        return ['', email];
      } else {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: "electrocare");

        final emailAuthCredential =
            EmailAuthProvider.credential(email: email, password: "electrocare");

        await _auth.signInWithCredential(emailAuthCredential);

        try {
          await _auth.currentUser!.linkWithCredential(credential);
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }

        return ['create', email];
      }
    } catch (e) {
      if (kDebugMode) {
        print("google sign in error $e");
      }
      return ['error', ''];
    }
  }

  //---------------------------------------- send reset password mail ----------------------------------------//

  Future<bool> sendResetPasswordMail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<dynamic> resetPassword(String oobCode, String newPassword) async {
    try {
      dynamic data = {
        "oobCode": oobCode,
        "newPassword": newPassword,
      };

      var response = await dio.post(
        resetPassUrl,
        data: jsonEncode(data),
      );

      return response.data;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
