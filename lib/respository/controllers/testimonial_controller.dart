import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/models/testimonial_model.dart';
import 'package:get/get.dart';

class TestimonialController extends GetxController {
  final _db = FirebaseFirestore.instance;

  RxList<TestimonialModel> testimonials = <TestimonialModel>[].obs;

  Future<void> fetchTestimonials() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection("feedbacks")
          .orderBy('rating', descending: true)
          .get();

      testimonials.value =
          snapshot.docs.map((e) => TestimonialModel.fromSnapshot(e)).toList();
    } catch (e) {
      log(e.toString());
    }
  }
}
