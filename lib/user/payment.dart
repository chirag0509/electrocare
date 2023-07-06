import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/repository/database/handleService.dart';
import 'package:electrocare/repository/models/serviceModel.dart';
import 'package:electrocare/user/paymentDone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../repository/controller/colorController.dart';

class Payment extends StatefulWidget {
  final ServiceModel service;
  const Payment({Key? key, required this.service}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final color = ColorController.instance;
  String? imageUrl;

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

    int totalCharge = widget.service.serviceCharge +
        widget.service.repairCharge +
        widget.service.setupCharge +
        widget.service.deliveryCharge;

    Timestamp timestamp = widget.service.time;

    DateTime dateTime = timestamp.toDate();

    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);

    String formattedTime = DateFormat('HH:mm').format(dateTime);

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
          child: Column(
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
                              widget.service.model.capitalize.toString(),
                              style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20, bottom: 20),
                            child: Text(
                              widget.service.appliance.capitalize.toString(),
                              style: TextStyle(
                                  fontSize: w * 0.035,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        height: 120,
                        width: 120,
                        child: imageUrl != null
                            ? CachedNetworkImage(imageUrl: imageUrl.toString())
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
                    color: widget.service.paymentStatus == "pending"
                        ? const Color.fromARGB(255, 255, 233, 200)
                        : Color.fromARGB(255, 208, 255, 210),
                    border: Border.all(
                        width: 2,
                        color: widget.service.paymentStatus == "pending"
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                widget.service.serviceStatus.capitalize
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                widget.service.paymentStatus.capitalize
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                "₹ ${widget.service.serviceCharge}",
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                "₹ ${widget.service.repairCharge}",
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                "₹ ${widget.service.setupCharge}",
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                "₹ ${widget.service.deliveryCharge}",
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              if (widget.service.paymentStatus == "pending")
                SizedBox(
                  child: totalCharge != 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: InkWell(
                            onTap: () async {
                              final service = await ServiceModel(
                                  id: widget.service.id,
                                  appliance: widget.service.appliance,
                                  repairCharge: widget.service.repairCharge,
                                  setupCharge: widget.service.setupCharge,
                                  serviceCharge: widget.service.serviceCharge,
                                  deliveryCharge: widget.service.deliveryCharge,
                                  model: widget.service.model,
                                  paymentStatus: "paid",
                                  problem: widget.service.problem,
                                  serviceStatus: widget.service.serviceStatus,
                                  time: Timestamp.now());

                              await serviceController
                                  .updateService(service)
                                  .then((_) => Get.to(() => PaymentDone()));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
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
                )
            ],
          ),
        ),
      ),
    ));
  }
}
