import 'dart:convert';

import 'package:electrocare/utils/shared_pref_helper.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayPayment {
  final String url = "https://api.razorpay.com/v1/orders";
  final String keyId = "rzp_test_vJJKKmL5MWj6sg";
  final String keySecret = "Wiq4lSvR0KL4l6CqAjlD8223";

  final _razorpay = Razorpay();

  Function(PaymentSuccessResponse)? _onPaymentSuccessCallback;
  Function(PaymentFailureResponse)? _onPaymentFailureCallback;

  dynamic options(String orderId, String description, int amount) {
    return {
      'key': keyId,
      'amount': amount * 100, //in the smallest currency sub-unit.
      'name': 'Electrocare',
      'order_id': orderId, // Generate order_id using Orders API
      'description': description,
      'timeout': 300, // in seconds
      'prefill': {
        'contact': SharedPreferencesHelper.getPhone(),
        'email': SharedPreferencesHelper.getEmail(),
      }
    };
  }

  void openCheckout(
      String orderId,
      String description,
      int amount,
      Function(PaymentSuccessResponse) onPaymentSuccess,
      Function(PaymentFailureResponse) onPaymentFailure) {
    _onPaymentSuccessCallback = onPaymentSuccess;
    _onPaymentFailureCallback = onPaymentFailure;
    _razorpay.open(options(orderId, description, amount));
  }

  void onPaymentSuccess() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  }

  void onPaymentError() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void onExternalWallet() {
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("payment success: ${response.data}");
    if (_onPaymentSuccessCallback != null) {
      _onPaymentSuccessCallback!(response);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("payment failure: ${response.error}");
    if (_onPaymentFailureCallback != null) {
      _onPaymentFailureCallback!(response);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("external wallet: ${response.walletName}");
  }

  void clear() {
    _razorpay.clear();
  }
}

RazorPayPayment razorpayPayment = RazorPayPayment();
