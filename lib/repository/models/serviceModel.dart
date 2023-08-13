import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String? id;
  final String client;
  final String clientPhone;
  final String clientAddress;
  final String executive;
  final String executiveID;
  final String appliance;
  final String model;
  final String problem;
  final String paymentStatus;
  final String serviceStatus;
  final int repairCharge;
  final int serviceCharge;
  final int setupCharge;
  final int deliveryCharge;
  final Timestamp time;

  const ServiceModel({
    this.id,
    required this.client,
    required this.clientPhone,
    required this.clientAddress,
    required this.executive,
    required this.executiveID,
    required this.appliance,
    required this.model,
    required this.problem,
    required this.paymentStatus,
    required this.serviceStatus,
    required this.repairCharge,
    required this.serviceCharge,
    required this.setupCharge,
    required this.deliveryCharge,
    required this.time,
  });

  toJson() {
    return {
      "client": client,
      "clientPhone": clientPhone,
      "clientAddress": clientAddress,
      "executive": executive,
      "executiveID": executiveID,
      "appliance": appliance,
      "model": model,
      "problem": problem,
      "paymentStatus": paymentStatus,
      "serviceStatus": serviceStatus,
      "repairCharge": repairCharge,
      "serviceCharge": serviceCharge,
      "setupCharge": setupCharge,
      "deliveryCharge": deliveryCharge,
      "time": time,
    };
  }

  factory ServiceModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ServiceModel(
      id: document.id,
      client: data["client"],
      clientPhone: data["clientPhone"],
      clientAddress: data["clientAddress"],
      executive: data["executive"],
      executiveID: data["executiveID"],
      appliance: data["appliance"],
      model: data["model"],
      problem: data["problem"],
      paymentStatus: data["paymentStatus"],
      serviceStatus: data["serviceStatus"],
      repairCharge: data["repairCharge"],
      serviceCharge: data["serviceCharge"],
      setupCharge: data["setupCharge"],
      deliveryCharge: data["deliveryCharge"],
      time: data["time"],
    );
  }
}
