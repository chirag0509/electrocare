import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/repository/models/componentModel.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HandleCategories extends GetxController {
  static HandleCategories get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Stream<Set<dynamic>> getCategories() {
    return _db.collection("components").snapshots().map((event) {
      Set<dynamic> categories = event.docs
          .map((doc) => doc.data()["category"])
          .where((category) => category != "personal")
          .toSet();
      categories.remove("popular");
      categories = {"popular", ...categories};
      return categories;
    });
  }

  Stream<List> getComponents(String category) {
    if (category == "popular") {
      return _db
          .collection("feedbacks")
          .snapshots()
          .map((event) => event.docs)
          .asyncMap((feedbackDocs) async {
        // Step 1: Count occurrences for each appliance
        Map<String, int> applianceOccurrences = {};

        for (var feedbackDoc in feedbackDocs) {
          String appliance = feedbackDoc['appliance'];

          applianceOccurrences[appliance] =
              (applianceOccurrences[appliance] ?? 0) + 1;
        }

        // Step 2: Sort appliances based on occurrences in descending order
        List<MapEntry<String, int>> sortedAppliances =
            applianceOccurrences.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

        // Step 3: Fetch top 5 components based on appliance names
        List<String> top5Appliances =
            sortedAppliances.take(5).map((entry) => entry.key).toList();

        if (top5Appliances.isEmpty) {
          // Fetch 5 components from the "components" collection if top 5 appliances are empty
          var componentsSnapshot = await _db
              .collection("components")
              .limit(5) // Limit the query to 5 documents
              .get();

          return componentsSnapshot.docs;
        } else {
          var componentsSnapshot = await _db
              .collection("components")
              .where(FieldPath.documentId, whereIn: top5Appliances)
              .get();

          return componentsSnapshot.docs;
        }
      }).map((snapshots) =>
              snapshots.map((e) => ComponentModel.fromSnapshot(e)).toList());
    } else {
      return _db
          .collection("components")
          .where('category', isEqualTo: category)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => ComponentModel.fromSnapshot(e)).toList());
    }
  }

  Stream<List<ComponentModel>> componentsList() {
    return _db.collection("components").snapshots().map((event) =>
        event.docs.map((e) => ComponentModel.fromSnapshot(e)).toList());
  }
}
