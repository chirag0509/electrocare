import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/models/category_model.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final _db = FirebaseFirestore.instance;

  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  Future<void> fetchCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection("categories").orderBy('order').get();

      categories.value =
          snapshot.docs.map((e) => CategoryModel.fromSnapshot(e)).toList();
    } catch (e) {
      log(e.toString());
    }
  }
}
