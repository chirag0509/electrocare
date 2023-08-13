import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String? id;
  final String name;
  final String email;
  final String executiveID;
  final String appliance;
  final String category;
  final int rating;
  final String review;
  final String transactionID;
  final Timestamp time;

  const FeedbackModel({
    this.id,
    required this.name,
    required this.email,
    required this.executiveID,
    required this.appliance,
    required this.category,
    required this.rating,
    required this.review,
    required this.transactionID,
    required this.time,
  });

  toJson() {
    return {
      "name": name,
      "email": email,
      "executiveID": executiveID,
      "appliance": appliance,
      "category": category,
      "rating": rating,
      "review": review,
      "transactionID": transactionID,
      "time": time,
    };
  }

  factory FeedbackModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return FeedbackModel(
      id: document.id,
      name: data["name"],
      email: data["email"],
      executiveID: data["executiveID"],
      appliance: data["appliance"],
      category: data["category"],
      rating: data["rating"],
      review: data["review"],
      transactionID: data["transactionID"],
      time: data["time"],
    );
  }
}
