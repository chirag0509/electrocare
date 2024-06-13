import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String image;
  final int msc;
  final Map<String, dynamic> mrc;

  const ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.msc,
    required this.mrc,
  });

  factory ProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProductModel(
      id: document.id,
      name: data["name"],
      image: data["image"],
      msc: data["msc"],
      mrc: data["mrc"],
    );
  }
}
