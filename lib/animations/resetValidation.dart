
import 'package:electrocare/repository/authentication/auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ResetValidation extends StatefulWidget {
  const ResetValidation({super.key});

  @override
  State<ResetValidation> createState() => _ResetValidationState();
}

class _ResetValidationState extends State<ResetValidation> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() async {
        Auth.instance.isResettingPassword = false;
        await Auth.instance.logout();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Lottie.asset("assets/animations/resetPsk.json",
                width: w * 0.7, repeat: false),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Password Reset Successfully",
              style: TextStyle(fontSize: w * 0.07, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ));
  }
}
