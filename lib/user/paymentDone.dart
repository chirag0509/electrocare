import 'dart:developer';

import 'package:electrocare/user/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class PaymentDone extends StatefulWidget {
  const PaymentDone({Key? key});

  @override
  State<PaymentDone> createState() => _PaymentDoneState();
}

class _PaymentDoneState extends State<PaymentDone>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;


  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller.forward().whenComplete(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Lottie.asset("assets/animations/GpayTick.json",
              controller: _controller, onLoaded: (composition) {
            _controller.duration = composition.duration;
          }),
        ),
      ),
    );
  }
}
