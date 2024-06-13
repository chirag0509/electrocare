import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/models/product_model.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final _db = FirebaseFirestore.instance;

  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<ProductModel> filteredProducts = <ProductModel>[].obs;

  Future<void> fetchProducts(String productId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection("categories")
          .doc(productId)
          .collection("products")
          .get();

      products.value =
          snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();

      filteredProducts.value = products.value;
    } catch (e) {
      log(e.toString());
    }
  }
}
