import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/models/technician_model.dart';
import 'package:get/get.dart';

class TechnicianController extends GetxController {
  final _db = FirebaseFirestore.instance;

  RxList<TechnicianModel> technicians = <TechnicianModel>[].obs;

  Future<void> fetchTechnicians() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection("technicians")
          .orderBy('rating', descending: true)
          .get();

      technicians.value =
          snapshot.docs.map((e) => TechnicianModel.fromSnapshot(e)).toList();
    } catch (e) {
      log(e.toString());
    }
  }
}
