import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  final String id;
  final String offer;
  final String discount;
  final String image;
  final Timestamp validity;

  const OfferModel({
    required this.id,
    required this.offer,
    required this.discount,
    required this.image,
    required this.validity,
  });

  factory OfferModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return OfferModel(
      id: document.id,
      offer: data["offer"],
      discount: data["discount"],
      image: data["image"],
      validity: data["validity"],
    );
  }
}
