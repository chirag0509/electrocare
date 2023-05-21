import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/repository/authentication/auth.dart';
import 'package:get/get.dart';

import '../models/userModel.dart';

class HandleUser extends GetxController {
  static HandleUser get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection("users").doc(user.email).set(user.toJson());
    } catch (e) {
      print(e);
    }
  }

  Stream<UserModel> getUserDetails() {
    return _db.collection("users").snapshots().map((event) => event.docs
        .map((e) => UserModel.fromSnapshot(e))
        .singleWhere(
            (user) => user.email == Auth.instance.firebaseUser.value!.email));
  }
}
