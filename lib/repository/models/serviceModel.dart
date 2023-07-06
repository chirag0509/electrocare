import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String? id;
  final String appliance;
  final String model;
  final String paymentStatus;
  final String problem;
  final String serviceStatus;
  final int repairCharge;
  final int serviceCharge;
  final int setupCharge;
  final int deliveryCharge;
  final Timestamp time;

  const ServiceModel({
    this.id,
    required this.appliance,
    required this.repairCharge,
    required this.setupCharge,
    required this.serviceCharge,
    required this.deliveryCharge,
    required this.model,
    required this.paymentStatus,
    required this.problem,
    required this.serviceStatus,
    required this.time,
  });

  toJson() {
    return {
      "appliance": appliance,
      "deliveryCharge": deliveryCharge,
      "serviceCharge": serviceCharge,
      "repairCharge": repairCharge,
      "setupCharge": setupCharge,
      "model": model,
      "paymentStatus": paymentStatus,
      "problem": problem,
      "serviceStatus": serviceStatus,
      "time": time,
    };
  }

  factory ServiceModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ServiceModel(
      id: document.id,
      appliance: data["appliance"],
      repairCharge: data["repairCharge"],
      setupCharge: data["setupCharge"],
      serviceCharge: data["serviceCharge"],
      deliveryCharge: data["deliveryCharge"],
      model: data["model"],
      paymentStatus: data["paymentStatus"],
      problem: data["problem"],
      serviceStatus: data["serviceStatus"],
      time: data["time"],
    );
  }
}
