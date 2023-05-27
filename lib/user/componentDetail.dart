import 'package:cached_network_image/cached_network_image.dart';
import 'package:electrocare/repository/controller/colorController.dart';
import 'package:electrocare/repository/database/handleService.dart';
import 'package:electrocare/repository/database/handleUser.dart';
import 'package:electrocare/repository/models/componentModel.dart';
import 'package:electrocare/repository/models/serviceModel.dart';
import 'package:electrocare/repository/models/userModel.dart';
import 'package:electrocare/user/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class ComponentDetail extends StatefulWidget {
  final ComponentModel component;
  const ComponentDetail({Key? key, required this.component}) : super(key: key);

  @override
  State<ComponentDetail> createState() => _ComponentDetailState();
}

class _ComponentDetailState extends State<ComponentDetail> {
  final color = ColorController.instance;

  bool isChatOpen = false;

  final model = TextEditingController();
  final problem = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final serviceController = Get.put(HandleService());
  final userController = Get.put(HandleUser());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: color.secondary,
        elevation: 0,
        iconTheme: IconThemeData(color: color.black, size: w * 0.075),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(Icons.shopping_cart_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: w * 1,
                height: h * 0.45,
                color: color.secondary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Fix ${widget.component.id.capitalize}",
                        style: TextStyle(
                            fontSize: w * 0.06, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: 250,
                        height: 250,
                        child: CachedNetworkImage(
                            imageUrl: widget.component.image)),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: color.white,
                          ),
                          child: RatingBar.builder(
                            initialRating: widget.component.rating.toDouble(),
                            minRating: 1,
                            maxRating: 5,
                            itemSize: 20,
                            ignoreGestures: true,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            unratedColor: Colors.grey.shade300,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.yellow.shade800,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: Container(
                    width: w * 0.7,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: color.secondary,
                    ),
                    child: Center(
                      child: Text(
                        "Reviews",
                        style: TextStyle(
                            fontSize: w * 0.04, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isChatOpen = !isChatOpen;
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: color.black,
                      ),
                      child: isChatOpen
                          ? Icon(
                              Icons.close,
                              color: color.white,
                              size: w * 0.06,
                            )
                          : Icon(
                              Icons.chat_outlined,
                              color: color.white,
                              size: w * 0.06,
                            )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: isChatOpen
                  ? StreamBuilder<UserModel>(
                      stream: userController.getUserDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: TextFormField(
                                    controller: model,
                                    style: TextStyle(fontSize: w * 0.04),
                                    decoration: InputDecoration(
                                        labelText: "Model",
                                        hintText: "Enter your Util Model",
                                        labelStyle:
                                            TextStyle(fontSize: w * 0.04),
                                        hintStyle:
                                            TextStyle(fontSize: w * 0.04),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 18),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your ${widget.component.id} model';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: TextFormField(
                                    controller: problem,
                                    style: TextStyle(fontSize: w * 0.04),
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                        alignLabelWithHint: true,
                                        labelText: "Problem",
                                        hintText: "Enter your Util Problem",
                                        labelStyle:
                                            TextStyle(fontSize: w * 0.04),
                                        hintStyle:
                                            TextStyle(fontSize: w * 0.04),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 18),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your ${widget.component.id} problem';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: InkWell(
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (snapshot.data!.address != "") {
                                          final service = ServiceModel(
                                              userName: snapshot.data!.name,
                                              userAdd: snapshot.data!.address,
                                              userPhone: snapshot.data!.phone,
                                              appliance: widget.component.id,
                                              model: model.text,
                                              problem: problem.text);
                                          await serviceController
                                              .createService(service);
                                        } else {
                                          Get.showSnackbar(GetSnackBar(
                                            message:
                                                'Please complete your profile.',
                                            duration: Duration(seconds: 2),
                                            backgroundColor:
                                                Color.fromARGB(255, 25, 25, 25),
                                          ));
                                          Get.to(() => Profile());
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: color.black,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Submit",
                                          style: TextStyle(
                                              fontSize: w * 0.045,
                                              fontWeight: FontWeight.w500,
                                              color: color.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      })
                  : Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text("Minimum Repair Charge",
                                      style: TextStyle(fontSize: w * 0.035)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    "${widget.component.mrc} ₹",
                                    style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text("Minimum Service Charge",
                                      style: TextStyle(fontSize: w * 0.035)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text("${widget.component.msc} ₹",
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text("Setup Charge",
                                      style: TextStyle(fontSize: w * 0.035)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text("${widget.component.sc} ₹",
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text("Delivery Charge",
                                      style: TextStyle(fontSize: w * 0.035)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text("${widget.component.dc} ₹",
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                  "*Repair and Service Charge may vary upon your product.",
                                  style: TextStyle(
                                      fontSize: w * 0.03, color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    ));
  }
}
