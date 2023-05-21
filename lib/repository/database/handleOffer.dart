import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HandleOffer extends GetxController {
  static HandleOffer get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Stream<List> getOffers() {
    return _db
        .collection("offers")
        .orderBy('valid')
        .snapshots()
        .map((event) => event.docs.toList());
  }
}
