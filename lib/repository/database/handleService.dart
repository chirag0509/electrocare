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
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("services")
          .add(service.toJson());
    } catch (e) {
      print(e);
    }
  }

  Stream<List<ServiceModel>> getServices(String status) {
    if (status != "all") {
      return _db
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("services")
          .orderBy("time", descending: true)
          .snapshots()
          .map((event) => event.docs
              .map((e) => ServiceModel.fromSnapshot(e))
              .where((element) => element.serviceStatus == status)
              .toList());
    } else {
      return _db
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("services")
          .orderBy('time', descending: true)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => ServiceModel.fromSnapshot(e)).toList());
    }
  }

  Future<void> updateService(ServiceModel service) async {
    try {
      await _db
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("services")
          .doc(service.id)
          .update(service.toJson());
    } catch (e) {
      print(e);
    }
  }
}
