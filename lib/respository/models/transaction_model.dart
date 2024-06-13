import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String? id;
  final String orderId;
  final String description;
  final String requestId; // repair requestId
  final int amount;
  final String type; // credit , debit
  final String status;
  final String userId;
  final Timestamp createdAt;

  const TransactionModel({
    this.id,
    required this.orderId,
    required this.description,
    required this.requestId,
    required this.amount,
    required this.type,
    required this.status,
    required this.userId,
    required this.createdAt,
  });

  toJson() {
    return {
      "orderId": orderId,
      "description": description,
      "requestId": requestId,
      "amount": amount,
      "type": type,
      "status": status,
      "userId": userId,
      "createdAt": createdAt,
    };
  }

  factory TransactionModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TransactionModel(
      id: document.id,
      orderId: data["orderId"],
      description: data["description"],
      requestId: data["requestId"],
      amount: data["amount"],
      type: data["type"],
      status: data["status"],
      userId: data["userId"],
      createdAt: data["createdAt"],
    );
  }
}
