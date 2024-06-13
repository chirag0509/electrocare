import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/models/offer_model.dart';
import 'package:get/get.dart';

class OfferController extends GetxController {
  final _db = FirebaseFirestore.instance;

  RxList<OfferModel> offers = <OfferModel>[].obs;

  Future<void> fetchOffers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection("offers").orderBy('validity').get();

      offers.value =
          snapshot.docs.map((e) => OfferModel.fromSnapshot(e)).toList();
    } catch (e) {
      log(e.toString());
    }
  }
}
