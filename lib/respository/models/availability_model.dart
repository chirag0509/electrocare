import 'package:cloud_firestore/cloud_firestore.dart';

class AvailabilityModel {
  final String id;
  final String brand;
  final String model;
  final String image;
  final List<Map<String, dynamic>> parts;

  const AvailabilityModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.image,
    required this.parts,
  });

  factory AvailabilityModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return AvailabilityModel(
      id: document.id,
      brand: data["brand"],
      model: data["model"],
      image: data["image"],
      parts: data["parts"],
    );
  }
}
