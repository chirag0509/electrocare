import 'package:cloud_firestore/cloud_firestore.dart';

class ComponentModel {
  final String? id;
  final String image;
  final String category;
  final String popular;
  final int rating;

  const ComponentModel({
    this.id,
    required this.category,
    required this.popular,
    required this.image,
    required this.rating,
  });

  toJson() {
    return {
      "category": category,
      "popular": popular,
      "image": image,
      "rating": rating,
    };
  }

  factory ComponentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ComponentModel(
      id: document.id,
      category: data["category"],
      popular: data["popular"],
      image: data["image"],
      rating: data["rating"],
    );
  }
}
