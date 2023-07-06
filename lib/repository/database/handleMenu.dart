import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/repository/models/serviceModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HandleMenu extends GetxController {
  static HandleMenu get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Stream<List> getTerms() {
    return _db
        .collection("terms")
        .orderBy('time')
        .snapshots()
        .map((event) => event.docs.toList());
  }
}
