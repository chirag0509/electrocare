import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/models/availability_model.dart';
import 'package:electrocare/respository/models/repair_request_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AvailabilityController extends GetxController {
  final _db = FirebaseFirestore.instance;

  AvailabilityModel? availabilityModel;

  Future<AvailabilityModel?> checkAvailability(
      String categoryId, String deviceId, String brand, String model) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection("categories")
          .doc(categoryId)
          .collection("products")
          .doc(deviceId)
          .collection("repairableDevices")
          .where("brand", isEqualTo: brand)
          .where("model", isEqualTo: model)
          .get();

      var doc = snapshot.docs.single;

      List<dynamic> parts = doc.data()['parts'];

      List<Map<String, dynamic>> updatedParts = parts.map((part) {
        return {
          "name": part["name"],
          "price": part["price"],
          "availability": part["quantity"] > 0 ? "available" : "not available"
        };
      }).toList();
      availabilityModel = AvailabilityModel(
        id: doc.id,
        brand: doc.data()['brand'],
        model: doc.data()['model'],
        image: doc.data()['image'],
        parts: updatedParts,
      );
      return availabilityModel;
    } catch (e) {
      if (kDebugMode) print(e);
    }
    return null;
  }
}
