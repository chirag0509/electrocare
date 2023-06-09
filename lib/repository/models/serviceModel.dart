import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String? id;
  final String appliance;
  final String charge;
  final String model;
  final String paymentStatus;
  final String problem;
  final String serviceStatus;
  final Timestamp time;

  const ServiceModel({
    this.id,
    required this.appliance,
    required this.charge,
    required this.model,
    required this.paymentStatus,
    required this.problem,
    required this.serviceStatus,
    required this.time,
  });

  toJson() {
    return {
      "appliance": appliance,
      "charge": charge,
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
      charge: data["charge"],
      model: data["model"],
      paymentStatus: data["paymentStatus"],
      problem: data["problem"],
      serviceStatus: data["serviceStatus"],
      time: data["time"],
    );
  }
}
