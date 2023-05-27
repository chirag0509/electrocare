import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/repository/models/serviceModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HandleService extends GetxController {
  static HandleService get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> createService(ServiceModel service) async {
    try {
      await _db
          .collection("services")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .set(service.toJson());
    } catch (e) {
      print(e);
    }
  }
}
