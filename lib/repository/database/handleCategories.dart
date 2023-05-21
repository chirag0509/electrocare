import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/repository/models/componentModel.dart';
import 'package:get/get.dart';

class HandleCategories extends GetxController {
  static HandleCategories get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Stream<Set<dynamic>> getCategories() {
    return _db.collection("components").snapshots().map((event) {
      Set<dynamic> categories = event.docs
          .map((doc) => doc.data()["category"])
          .where((category) => category != "personal")
          .toSet();
      categories.remove("popular");
      categories = {"popular", ...categories};
      return categories;
    });
  }

  Stream<List<ComponentModel>> getComponents(String category) {
    if (category == "popular") {
      return _db.collection("components").snapshots().map((event) => event.docs
          .map((e) => ComponentModel.fromSnapshot(e))
          .where((element) => element.popular == "yes")
          .toList());
    } else {
      return _db
          .collection("components")
          .where('category', isEqualTo: category)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => ComponentModel.fromSnapshot(e)).toList());
    }
  }

  Stream<List<ComponentModel>> componentsList() {
    return _db.collection("components").snapshots().map((event) =>
        event.docs.map((e) => ComponentModel.fromSnapshot(e)).toList());
  }
}
