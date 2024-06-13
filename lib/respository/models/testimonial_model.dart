import 'package:cloud_firestore/cloud_firestore.dart';

class TestimonialModel {
  final String id;
  final String name;
  final String feedback;
  final String image;
  final dynamic rating;

  const TestimonialModel({
    required this.id,
    required this.name,
    required this.feedback,
    required this.image,
    required this.rating,
  });

  factory TestimonialModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TestimonialModel(
      id: document.id,
      name: data["name"],
      feedback: data["feedback"],
      image: data["image"],
      rating: data["rating"],
    );
  }
}
