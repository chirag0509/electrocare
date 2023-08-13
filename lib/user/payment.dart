import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/repository/authentication/auth.dart';
import 'package:electrocare/repository/database/handleService.dart';
import 'package:electrocare/repository/models/serviceModel.dart';
import 'package:electrocare/user/paymentDone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../repository/controller/colorController.dart';
import '../repository/models/feedbackModel.dart';

class Payment extends StatefulWidget {
  final ServiceModel service;
  const Payment({Key? key, required this.service}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final color = ColorController.instance;
  String? imageUrl;

  int _rating = 0;
  final TextEditingController msgEditingController = TextEditingController();
  bool isEnabled = false;

  String _compCategory = "";

  @override
  void initState() {
    loadImage();
    super.initState();
  }

  Future<void> loadImage() async {
    final doc = await FirebaseFirestore.instance
        .collection("components")
        .doc(widget.service.appliance)
        .get();
    final image = doc.get('image');
    setState(() {
      imageUrl = image;
    });
  }

  final serviceController = Get.put(HandleService());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: color.black, size: w * 0.075),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("services")
                  .doc(widget.service.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Timestamp timestamp = snapshot.data!["time"];

                  DateTime dateTime = timestamp.toDate();

                  String formattedDate =
                      DateFormat('dd-MM-yyyy').format(dateTime);

                  String formattedTime = DateFormat('HH:mm').format(dateTime);

                  int totalCharge = snapshot.data!["repairCharge"] +
                      snapshot.data!["serviceCharge"] +
                      snapshot.data!["setupCharge"] +
                      snapshot.data!["deliveryCharge"];

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Payment",
                          style: TextStyle(
                            fontSize: w * 0.06,
                            fontWeight: FontWeight.w500,
                            color: color.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: color.secondary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 20, bottom: 10),
                                    child: Text(
                                      widget.service.model.capitalize
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: w * 0.04,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, bottom: 20),
                                    child: Text(
                                      widget.service.appliance.capitalize
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  if (snapshot.data!["serviceStatus"] ==
                                      "completed")
                                    StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("feedbacks")
                                          .snapshots()
                                          .map((event) => event.docs
                                              .map((e) =>
                                                  FeedbackModel.fromSnapshot(e))
                                              .where((element) =>
                                                  element.transactionID ==
                                                  snapshot.data!.id
                                                      .substring(0, 10))
                                              .toList()),
                                      builder: (context, feedSnap) {
                                        if (feedSnap.hasData) {
                                          if (feedSnap.data!.length == 0) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, bottom: 20),
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 25),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50))),
                                                  onPressed: () async {
                                                    final compDoc =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "components")
                                                            .doc(widget.service
                                                                .appliance)
                                                            .get();
                                                    if (compDoc.exists) {
                                                      _compCategory = compDoc
                                                          .get("category");
                                                    }
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                            return AlertDialog(
                                                              scrollable: true,
                                                              elevation: 3,
                                                              title: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      "Rate your Experience"),
                                                                  IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    icon: Icon(Icons
                                                                        .close),
                                                                    iconSize:
                                                                        30,
                                                                  )
                                                                ],
                                                              ),
                                                              content: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      'How would you Rate your Experience?'),
                                                                  SizedBox(
                                                                      height:
                                                                          16),
                                                                  RatingBuilder(
                                                                    rating:
                                                                        _rating,
                                                                    onChanged:
                                                                        (newRating) {
                                                                      setState(
                                                                          () {
                                                                        _rating =
                                                                            newRating;
                                                                      });
                                                                    },
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  TextFormField(
                                                                    controller:
                                                                        msgEditingController,
                                                                    textCapitalization:
                                                                        TextCapitalization
                                                                            .sentences,
                                                                    maxLines: 7,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      alignLabelWithHint:
                                                                          true,
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                      labelText:
                                                                          'Enter your Feedback:',
                                                                    ),
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        isEnabled =
                                                                            true;
                                                                      });
                                                                    },
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                              .length <=
                                                                          10) {
                                                                        setState(
                                                                            () {
                                                                          isEnabled =
                                                                              true;
                                                                        });
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          isEnabled =
                                                                              false;
                                                                        });
                                                                      }
                                                                      return null;
                                                                    },
                                                                    onSaved:
                                                                        (value) {
                                                                      msgEditingController
                                                                              .text =
                                                                          value!;
                                                                    },
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        1,
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          elevation:
                                                                              3),
                                                                      onPressed:
                                                                          () async {
                                                                        if (_rating >
                                                                                0 ||
                                                                            isEnabled ==
                                                                                true) {
                                                                          final feedback = await FeedbackModel(
                                                                              name: widget.service.client,
                                                                              email: Auth.instance.firebaseUser.value!.email.toString(),
                                                                              executiveID: widget.service.executiveID,
                                                                              appliance: widget.service.appliance,
                                                                              category: _compCategory,
                                                                              rating: _rating,
                                                                              review: msgEditingController.text,
                                                                              transactionID: widget.service.id!.substring(0, 10),
                                                                              time: Timestamp.now());
                                                                          await FirebaseFirestore
                                                                              .instance
                                                                              .collection("feedbacks")
                                                                              .add(feedback.toJson());
                                                                          Navigator.pop(
                                                                              context);
                                                                          Get.showSnackbar(
                                                                            GetSnackBar(
                                                                              message: "Feedback submitted successfully.",
                                                                              duration: Duration(seconds: 2),
                                                                              backgroundColor: Color.fromARGB(255, 35, 35, 35),
                                                                            ),
                                                                          );
                                                                        }
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Submit',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 16),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text("Rate")),
                                            );
                                          } else {
                                            return SizedBox();
                                          }
                                        } else {
                                          return SizedBox();
                                        }
                                      },
                                    ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                height: 120,
                                width: 120,
                                child: imageUrl != null
                                    ? CachedNetworkImage(
                                        imageUrl: imageUrl.toString())
                                    : SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: snapshot.data!["paymentStatus"] == "pending"
                                ? const Color.fromARGB(255, 255, 233, 200)
                                : Color.fromARGB(255, 208, 255, 210),
                            border: Border.all(
                                width: 2,
                                color:
                                    snapshot.data!["paymentStatus"] == "pending"
                                        ? Colors.orange
                                        : Colors.green),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(children: [
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: w * 0.4,
                                    child: Text(
                                      "Service Status",
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: w * 0.3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${snapshot.data!["serviceStatus"]}'
                                            .capitalize
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: w * 0.4,
                                    child: Text(
                                      "Payment Status",
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: w * 0.3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${snapshot.data!["paymentStatus"]}'
                                            .capitalize
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: w * 0.4,
                                    child: Text(
                                      "Executive",
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: w * 0.3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${snapshot.data!["executive"]}'
                                            .capitalize
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: w * 0.4,
                                    child: Text(
                                      "Executive ID",
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: w * 0.3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${snapshot.data!["executiveID"]}',
                                        style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: w * 0.4,
                                    child: Text(
                                      "Transaction ID",
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: w * 0.3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        widget.service.id!.substring(0, 10),
                                        style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: w * 0.4,
                                    child: Text(
                                      "Date",
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: w * 0.3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        formattedDate,
                                        style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: w * 0.4,
                                    child: Text(
                                      "Time",
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: w * 0.3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        formattedTime,
                                        style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: w * 0.4,
                                    child: Text(
                                      "Repair Charge",
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: w * 0.3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '₹ ${snapshot.data!["repairCharge"]}',
                                        style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: w * 0.4,
                                    child: Text(
                                      "Service Charge",
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: w * 0.3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '₹ ${snapshot.data!["serviceCharge"]}',
                                        style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: w * 0.4,
                                    child: Text(
                                      "Setup Charge",
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: w * 0.3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '₹ ${snapshot.data!["setupCharge"]}',
                                        style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: w * 0.4,
                                    child: Text(
                                      "Delivery Charge",
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: w * 0.3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '₹ ${snapshot.data!["deliveryCharge"]}',
                                        style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: w * 0.4,
                                    child: Text(
                                      "Total Charge",
                                      style: TextStyle(
                                          fontSize: w * 0.04,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                        fontSize: w * 0.04,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: w * 0.3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "₹ " + totalCharge.toString(),
                                        style: TextStyle(
                                            fontSize: w * 0.04,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (snapshot.data!["paymentStatus"] == "pending")
                        SizedBox(
                          child: totalCharge != 0
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  child: InkWell(
                                    onTap: () async {
                                      Get.to(() => PaymentDone());
                                      final service = await ServiceModel(
                                          id: snapshot.data!.id,
                                          client: snapshot.data!["client"],
                                          clientPhone:
                                              snapshot.data!["clientPhone"],
                                          clientAddress:
                                              snapshot.data!["clientAddress"],
                                          executive:
                                              snapshot.data!["executive"],
                                          executiveID:
                                              snapshot.data!["executiveID"],
                                          appliance:
                                              snapshot.data!["appliance"],
                                          model: snapshot.data!["model"],
                                          problem: snapshot.data!["problem"],
                                          serviceStatus: "in process",
                                          paymentStatus: "paid",
                                          repairCharge:
                                              snapshot.data!["repairCharge"],
                                          serviceCharge:
                                              snapshot.data!["serviceCharge"],
                                          setupCharge:
                                              snapshot.data!["setupCharge"],
                                          deliveryCharge:
                                              snapshot.data!["deliveryCharge"],
                                          time: Timestamp.now());

                                      await serviceController
                                          .updateService(service);
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
                                          "Pay",
                                          style: TextStyle(
                                              fontSize: w * 0.045,
                                              fontWeight: FontWeight.w500,
                                              color: color.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "Please confirm your service charge with our executive.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: w * 0.035),
                                  ),
                                ),
                        ),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    ));
  }
}

class RatingBuilder extends StatelessWidget {
  final int rating;
  final int maxRating;
  final IconData filledIcon;
  final IconData emptyIcon;
  final Color iconColor;
  final double iconSize;
  final ValueChanged<int> onChanged;

  RatingBuilder({
    required this.rating,
    this.maxRating = 5,
    this.filledIcon = Icons.star,
    this.emptyIcon = Icons.star_border,
    this.iconColor = Colors.orangeAccent,
    this.iconSize = 40,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxRating, (index) {
        final isSelected = index < rating;
        return InkWell(
          child: Icon(
            isSelected ? filledIcon : emptyIcon,
            color: iconColor,
            size: iconSize,
          ),
          onTap: () {
            onChanged(index + 1);
          },
        );
      }),
    );
  }
}
