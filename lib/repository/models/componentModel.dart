import 'package:cloud_firestore/cloud_firestore.dart';

class ComponentModel {
  final String id;
  final String image;
  final String category;
  final String mrc;
  final String msc;
  final String sc;
  final String dc;

  const ComponentModel({
    required this.id,
    required this.category,
    required this.image,
    required this.mrc,
    required this.msc,
    required this.sc,
    required this.dc,
  });

  toJson() {
    return {
      "category": category,
      "image": image,
      "mrc": mrc,
      "msc": msc,
      "sc": sc,
      "dc": dc,
    };
  }

  factory ComponentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ComponentModel(
      id: document.id,
      category: data["category"],
      image: data["image"],
      mrc: data["mrc"],
      msc: data["msc"],
      sc: data["sc"],
      dc: data["dc"],
    );
  }
}
