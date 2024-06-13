import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/models/repair_request_model.dart';
import 'package:electrocare/utils/shared_pref_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class RequestController extends GetxController {
  final _db = FirebaseFirestore.instance;

  RxList<RepairRequestModel> requests = <RepairRequestModel>[].obs;

  Future<bool> addRequest(RepairRequestModel request) async {
    try {
      await _db.collection("repairRequests").add(request.toJson());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<void> fetchAllRequests() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection("repairRequests")
          .where("user.email", isEqualTo: SharedPreferencesHelper.getEmail())
          .where("status", isNotEqualTo: "part not available")
          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedDocs =
          snapshot.docs;

      sortedDocs.sort((a, b) => (b.data()['createdAt'] as Timestamp)
          .compareTo(a.data()['createdAt'] as Timestamp));

      requests.value =
          sortedDocs.map((e) => RepairRequestModel.fromSnapshot(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> updateRequestStatus(String docId) async {
    try {
      DocumentSnapshot snapshot =
          await _db.collection("repairRequests").doc(docId).get();

      await snapshot.reference.update({
        'status': "completed",
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
