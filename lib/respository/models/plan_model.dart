import 'package:cloud_firestore/cloud_firestore.dart';

class PlanModel {
  final String id;
  final int order;
  final int price;
  final String validity;
  final int serviceDiscount;
  final int repairDiscount;
  final int cashback;
  final List<dynamic> benefits;

  const PlanModel({
    required this.id,
    required this.order,
    required this.price,
    required this.validity,
    required this.serviceDiscount,
    required this.repairDiscount,
    required this.cashback,
    required this.benefits,
  });

  factory PlanModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return PlanModel(
      id: document.id,
      order: data["order"],
      price: data["price"],
      validity: data["validity"],
      serviceDiscount: data["serviceDiscount"],
      repairDiscount: data["repairDiscount"],
      cashback: data["cashback"],
      benefits: data["benefits"],
    );
  }
}
