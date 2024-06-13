import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final int order;
  final String name;
  final String image;

  const CategoryModel({
    required this.id,
    required this.order,
    required this.name,
    required this.image,
  });

  factory CategoryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CategoryModel(
      id: document.id,
      order: data["order"],
      name: data["name"],
      image: data["image"],
    );
  }
}
