import 'package:cloud_firestore/cloud_firestore.dart';

class RepairRequestModel {
  final String? id;
  final String image;
  final String requestedBrand;
  final String requestedModel;
  final String deviceType;
  final String category;
  final List<Map<String, dynamic>> requestedParts;
  final Map<String, dynamic> user;
  final Map<String, dynamic> technician;
  final Map<String, dynamic> discounts;
  final String status;
  final int repairCharge;
  final int serviceCharge;
  final Timestamp createdAt;

  const RepairRequestModel({
    this.id,
    required this.image,
    required this.requestedBrand,
    required this.requestedModel,
    required this.deviceType,
    required this.category,
    required this.requestedParts,
    required this.user,
    required this.technician,
    required this.discounts,
    required this.status,
    required this.repairCharge,
    required this.serviceCharge,
    required this.createdAt,
  });

  toJson() {
    return {
      "image": image,
      "requestedBrand": requestedBrand,
      "requestedModel": requestedModel,
      "requestedParts": requestedParts,
      "deviceType": deviceType,
      "category": category,
      "user": user,
      "technician": technician,
      "discounts": discounts,
      "status": status,
      "repairCharge": repairCharge,
      "serviceCharge": serviceCharge,
      "createdAt": createdAt,
    };
  }

  factory RepairRequestModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return RepairRequestModel(
      id: document.id,
      image: data["image"],
      requestedBrand: data["requestedBrand"],
      requestedModel: data["requestedModel"],
      deviceType: data["deviceType"],
      category: data["category"],
      requestedParts: List<Map<String, dynamic>>.from(data["requestedParts"]),
      user: data["user"],
      technician: data["technician"],
      discounts: data["discounts"],
      status: data["status"],
      repairCharge: data["repairCharge"],
      serviceCharge: data["serviceCharge"],
      createdAt: data["createdAt"],
    );
  }
}
