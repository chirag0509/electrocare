import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:electrocare/main.dart';
import 'package:electrocare/respository/models/user_model.dart';
import 'package:electrocare/utils/common_widgets.dart';
import 'package:electrocare/utils/shared_pref_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final _db = FirebaseFirestore.instance;

  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString phone = ''.obs;
  RxString image = ''.obs;
  RxString city = ''.obs;
  RxString state = ''.obs;
  RxString address = ''.obs;
  RxInt balance = 0.obs;
  RxMap<String, dynamic> plan = <String, dynamic>{}.obs;
  RxString upiId = ''.obs;

  Dio dio = Dio();

  Future<bool> createUser(UserModel user) async {
    try {
      await _db.collection("users").add(user.toJson());

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> getUserDetails(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection("users").where("email", isEqualTo: email).get();

      UserModel user = UserModel.fromSnapshot(snapshot.docs.single);

      if (user.isActive) {
        firstName.value = user.firstName;
        lastName.value = user.lastName;
        phone.value = user.phone;
        image.value = user.image;
        balance.value = user.balance;
        plan.value = user.plan;
        upiId.value = user.upiId;

        SharedPreferencesHelper.setUserId(user.id!);
        SharedPreferencesHelper.setEmail(user.email);
        SharedPreferencesHelper.setPhone(user.phone);
        SharedPreferencesHelper.setIsLoggedIn(true);

        return true;
      } else {
        toastMsg("Your account has been suspended");

        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return false;
    }
  }

  Future<bool> getUserDetailsUsingPhone(String phone) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection("users").where("phone", isEqualTo: phone).get();

      UserModel user = UserModel.fromSnapshot(snapshot.docs.single);

      if (user.isActive) {
        firstName.value = user.firstName;
        lastName.value = user.lastName;
        this.phone.value = user.phone;
        image.value = user.image;
        balance.value = user.balance;
        plan.value = user.plan;
        upiId.value = user.upiId;

        SharedPreferencesHelper.setUserId(user.id!);
        SharedPreferencesHelper.setEmail(user.email);
        SharedPreferencesHelper.setPhone(user.phone);
        SharedPreferencesHelper.setIsLoggedIn(true);

        return true;
      } else {
        toastMsg("Your account has been suspended");

        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return false;
    }
  }

  Future<bool?> getUserStatus() async {
    try {
      if (phone.isNotEmpty) {
        QuerySnapshot<Map<String, dynamic>> snapshot = await _db
            .collection("users")
            .where("phone", isEqualTo: phone.value)
            .get();

        UserModel user = UserModel.fromSnapshot(snapshot.docs.single);

        if (user.isActive) {
          return true;
        } else {
          return false;
        }
      } else {
        QuerySnapshot<Map<String, dynamic>> snapshot = await _db
            .collection("users")
            .where("email", isEqualTo: SharedPreferencesHelper.getEmail())
            .get();

        UserModel user = UserModel.fromSnapshot(snapshot.docs.single);
        if (user.isActive) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<void> getUserLocation() async {
    try {
      final latitude = locationData!.latitude;
      final longitude = locationData!.longitude;

      var response = await dio.get(
          "http://api.openweathermap.org/geo/1.0/reverse?lat=$latitude&lon=$longitude&limit=1&appid=38b450585bd84deac076d59fcca5a1de");

      city.value = response.data[0]["name"];
      state.value = response.data[0]["state"];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> addUpi(String upiId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("users")
          .where(SharedPreferencesHelper.getEmail())
          .get();

      DocumentSnapshot documentSnapshot = snapshot.docs.first;

      await documentSnapshot.reference.update({
        'upiId': upiId,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> updatePlan(String name, int pricePaid, int cashback,
      int serviceDiscount, int repairDiscount) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("users")
          .where(SharedPreferencesHelper.getEmail())
          .get();

      DocumentSnapshot documentSnapshot = snapshot.docs.first;

      await documentSnapshot.reference.update({
        'plan.name': name,
        'plan.pricePaid': pricePaid,
        'plan.cashback': cashback,
        'plan.serviceDiscount': serviceDiscount,
        'plan.repairDiscount': repairDiscount,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
