import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:electrocare/respository/models/transaction_model.dart';
import 'package:electrocare/respository/transactions/razorpay_payment.dart';
import 'package:electrocare/utils/shared_pref_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class TransactionController extends GetxController {
  Dio dio = Dio();

  final _db = FirebaseFirestore.instance;

  RxList<TransactionModel> transactions = <TransactionModel>[].obs;

  Future<void> createOrder(
      String description,
      int amount,
      String receiptId,
      Function(PaymentSuccessResponse) onPaymentSuccess,
      Function(PaymentFailureResponse) onPaymentFailure) async {
    final String basicAuth =
        "Basic ${base64Encode(utf8.encode('${razorpayPayment.keyId}:${razorpayPayment.keySecret}'))}";

    try {
      final data = {
        "amount": amount * 100,
        "currency": "INR",
        "receipt": receiptId,
        "partial_payment": false,
      };

      var response = await dio.post(
        razorpayPayment.url,
        data: data,
        options: Options(headers: {
          "content-Type": "application/json",
          "authorization": basicAuth,
        }),
      );

      print("response $response");

      razorpayPayment.openCheckout(response.data["id"], description, amount,
          onPaymentSuccess, onPaymentFailure);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> updateAmount(int amount) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("users")
          .where(SharedPreferencesHelper.getEmail())
          .get();

      DocumentSnapshot documentSnapshot = snapshot.docs.first;

      await documentSnapshot.reference.update({
        'balance': amount,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _db.collection("transactions").add(transaction.toJson());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> fetchAllTransactions() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection("transactions")
          .where("userId", isEqualTo: SharedPreferencesHelper.getUserId())
          .orderBy("createdAt", descending: true)
          .get();

      transactions.value =
          snapshot.docs.map((e) => TransactionModel.fromSnapshot(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
