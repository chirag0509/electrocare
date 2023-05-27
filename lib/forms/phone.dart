import 'package:electrocare/forms/otp.dart';
import 'package:electrocare/repository/authentication/auth.dart';
import 'package:electrocare/repository/controller/formController.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contact.dart';

class Phone extends StatefulWidget {
  const Phone({super.key});

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  final fi = FormController.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: w * 0.08,
              )),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () {
                Get.to(() => Contact());
              },
              icon: Icon(
                Icons.support_agent,
                color: Colors.black,
                size: w * 0.1,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Text(
                      "Sign In with Phone",
                      style: TextStyle(
                          color: Color(0xFF8F1EFF),
                          fontWeight: FontWeight.w600,
                          fontSize: w * 0.1),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    controller: fi.phone,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: w * 0.045),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone_android_outlined),
                        labelText: "Phone",
                        hintText: "Enter your number",
                        prefixText: "+91",
                        prefixStyle: TextStyle(fontSize: w * 0.045),
                        labelStyle: TextStyle(fontSize: w * 0.045),
                        hintStyle: TextStyle(fontSize: w * 0.045),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your number';
                      } else if (value.length != 10) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await Auth.instance.phoneAuthentication(fi.phone.text);
                        Get.to(() => Otp(
                              name: "",
                              email: "",
                              phone: fi.phone.text,
                              password: "",
                            ));
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF8F1EFF),
                        borderRadius: BorderRadius.circular(w * 1),
                      ),
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.07,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
