import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String? id;
  final String userName;
  final String userAdd;
  final String userPhone;
  final String userEmail;
  final String appliance;
  final String model;
  final String problem;
  final String status;
  final Timestamp time;

  const ServiceModel({
    this.id,
    required this.userName,
    required this.userAdd,
    required this.userPhone,
    required this.userEmail,
    required this.appliance,
    required this.model,
    required this.problem,
    required this.status,
    required this.time,
  });

  toJson() {
    return {
      "userName": userName,
      "userAdd": userAdd,
      "userPhone": userPhone,
      "userEmail": userEmail,
      "appliance": appliance,
      "model": model,
      "problem": problem,
      "status": status,
      "time": time,
    };
  }

  factory ServiceModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ServiceModel(
      id: document.id,
      userName: data["userName"],
      userAdd: data["userAdd"],
      userPhone: data["userPhone"],
      userEmail: data["userEmail"],
      appliance: data["appliance"],
      model: data["model"],
      problem: data["problem"],
      status: data["status"],
      time: data["time"],
    );
  }
}
