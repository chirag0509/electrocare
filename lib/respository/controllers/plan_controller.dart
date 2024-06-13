import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/models/plan_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PlanController extends GetxController {
  final _db = FirebaseFirestore.instance;

  RxList<PlanModel> plans = <PlanModel>[].obs;

  Future<void> fetchPlans(int pricePaid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection("plans")
          .where("price", isGreaterThan: pricePaid)
          .orderBy('price')
          .get();

      plans.value =
          snapshot.docs.map((e) => PlanModel.fromSnapshot(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
