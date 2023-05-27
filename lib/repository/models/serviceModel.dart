import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String? id;
  final String userName;
  final String userAdd;
  final String userPhone;
  final String appliance;
  final String model;
  final String problem;

  const ServiceModel({
    this.id,
    required this.userName,
    required this.userAdd,
    required this.userPhone,
    required this.appliance,
    required this.model,
    required this.problem,
  });

  toJson() {
    return {
      "userName": userName,
      "userAdd": userAdd,
      "userPhone": userPhone,
      "appliance": appliance,
      "model": model,
      "problem": problem,
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
      appliance: data["appliance"],
      model: data["model"],
      problem: data["problem"],
    );
  }
}
