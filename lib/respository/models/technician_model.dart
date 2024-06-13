import 'package:cloud_firestore/cloud_firestore.dart';

class TechnicianModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final dynamic rating;
  final String image;

  const TechnicianModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.rating,
    required this.image,
  });

  factory TechnicianModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TechnicianModel(
      id: document.id,
      firstName: data["firstName"],
      lastName: data["lastName"],
      email: data["email"],
      rating: data["rating"],
      image: data["image"],
    );
  }
}
