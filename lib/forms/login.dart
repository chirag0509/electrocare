import 'package:electrocare/forms/contact.dart';
import 'package:electrocare/forms/forgetPsk.dart';
import 'package:electrocare/forms/phone.dart';
import 'package:electrocare/repository/authentication/auth.dart';
import 'package:electrocare/repository/controller/formController.dart';
import 'package:electrocare/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/controller/colorController.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                      "Sign In",
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    controller: fi.password,
                    style: TextStyle(fontSize: w * 0.045),
                    obscureText: !showPsk,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_open_outlined),
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(() => ForgetPsk());
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(fontSize: w * 0.05),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await Auth.instance.signInWithEmailAndPassword(
                            fi.email.text, fi.password.text, context);
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
                          "Login",
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
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 1,
                        color: color.black,
                        constraints: BoxConstraints(maxWidth: w * 0.2),
                      ),
                      Center(
                          child: Text(
                        "or continue with",
                        style: TextStyle(fontSize: w * 0.05),
                      )),
                      Container(
                        height: 1,
                        color: color.black,
                        constraints: BoxConstraints(maxWidth: w * 0.2),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => Phone());
                        },
                        child: Container(
                          width: w * 0.42,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(w * 1),
                              border: Border.all(width: 1)),
                          child: Icon(
                            Icons.phone,
                            color: Colors.blue,
                            size: w * 0.07,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await Auth.instance.signInWithGoogle(context);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: w * 0.42,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(w * 1),
                                border: Border.all(width: 1)),
                            child: Center(
                              child: Image.asset(
                                'assets/images/google.png',
                                width: w * 0.07,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                            fontSize: w * 0.05, fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, MyRoutes.register);
                        },
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Text(
                          "Sign Up",
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
