
import 'package:electrocare/forms/otp.dart';
import 'package:electrocare/repository/authentication/auth.dart';
import 'package:electrocare/repository/controller/colorController.dart';
import 'package:electrocare/repository/controller/formController.dart';
import 'package:electrocare/routes.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contact.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool showPsk = false;

  final fi = FormController.instance;
  final _formKey = GlobalKey<FormState>();

  final color = ColorController.instance;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;


    return SafeArea(
        child: Scaffold(
      backgroundColor: color.white,
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
                color: color.black,
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
                color: color.black,
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
                      "Sign Up",
                      style: TextStyle(
                          color: color.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: w * 0.1),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    controller: fi.name,
                    style: TextStyle(fontSize: w * 0.045),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_outlined),
                        labelText: "Name",
                        hintText: "Enter your name",
                        labelStyle: TextStyle(fontSize: w * 0.045),
                        hintStyle: TextStyle(fontSize: w * 0.045),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter your name';
                      } else if (value.length < 3) {
                        return 'Please check the name you entered';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    controller: fi.email,
                    style: TextStyle(fontSize: w * 0.045),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: "Email",
                        hintText: "Enter your email",
                        labelStyle: TextStyle(fontSize: w * 0.045),
                        hintStyle: TextStyle(fontSize: w * 0.045),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter your email';
                      } else if (!RegExp(fi.emailRegex).hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
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
                      if (value == null) {
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
                  child: TextFormField(
                    controller: fi.password,
                    style: TextStyle(fontSize: w * 0.045),
                    obscureText: !showPsk,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_open),
                        suffixIcon: showPsk
                            ? IconButton(
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    showPsk = !showPsk;
                                  });
                                },
                                icon: Icon(Icons.visibility_off_outlined))
                            : IconButton(
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    showPsk = !showPsk;
                                  });
                                },
                                icon: Icon(Icons.visibility_outlined)),
                        labelText: "Password",
                        hintText: "Enter a strong password",
                        labelStyle: TextStyle(fontSize: w * 0.045),
                        hintStyle: TextStyle(fontSize: w * 0.045),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter a password';
                      } else if (value.length < 6) {
                        return 'Password must be atleast of 6 characters';
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
                              name: fi.name.text,
                              email: fi.email.text,
                              phone: fi.phone.text,
                              password: fi.password.text,
                            ));
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: color.black,
                        borderRadius: BorderRadius.circular(w * 1),
                      ),
                      child: Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                              color: color.white,
                              fontSize: w * 0.07,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have and account? ",
                        style: TextStyle(
                            fontSize: w * 0.05, fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, MyRoutes.login);
                        },
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                              color: color.primary,
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
