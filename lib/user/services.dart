import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/repository/controller/colorController.dart';
import 'package:electrocare/repository/database/handleService.dart';
import 'package:electrocare/repository/models/serviceModel.dart';
import 'package:electrocare/user/payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final color = ColorController.instance;
  final serviceController = Get.put(HandleService());

  String newStatus = "pending";

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Services",
                  style: TextStyle(
                    fontSize: w * 0.06,
                    fontWeight: FontWeight.w500,
                    color: color.black,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 3.5,
                      crossAxisCount: 2),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    List<String> title = [
                      "pending",
                      "completed",
                      "in process",
                      "all"
                    ];
                    List<Color> colors = [
                      Color(0xFFCAE9F1),
                      color.tertiary,
                      Color(0xFFD1D4FA),
                      Color(0xFFF3E1F7),
                    ];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          newStatus = title[index];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: colors[index],
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          title[index].capitalize.toString(),
                          style: TextStyle(
                              fontSize: w * 0.04, fontWeight: FontWeight.w500),
                        )),
                      ),
                    );
                  },
                ),
              ),
              StreamBuilder<List<ServiceModel>>(
                stream: serviceController.getServices(newStatus),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length != 0) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Timestamp timestamp = snapshot.data![index].time;

                          DateTime dateTime = timestamp.toDate();

                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(dateTime);

                          String formattedTime =
                              DateFormat('HH:mm').format(dateTime);

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 20),
                            child: InkWell(
                              onTap: () async {
                                final service = await ServiceModel(
                                    id: snapshot.data![index].id,
                                    appliance: snapshot.data![index].appliance,
                                    repairCharge:
                                        snapshot.data![index].repairCharge,
                                    serviceCharge:
                                        snapshot.data![index].serviceCharge,
                                    setupCharge:
                                        snapshot.data![index].setupCharge,
                                    deliveryCharge:
                                        snapshot.data![index].deliveryCharge,
                                    model: snapshot.data![index].model,
                                    paymentStatus:
                                        snapshot.data![index].paymentStatus,
                                    problem: snapshot.data![index].problem,
                                    serviceStatus:
                                        snapshot.data![index].serviceStatus,
                                    time: snapshot.data![index].time);
                                await Get.to(() => Payment(service: service));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color.secondary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, left: 20, bottom: 10),
                                          child: Text(
                                            snapshot.data![index].model
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: w * 0.04,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
<<<<<<< HEAD
                                              left: 20, bottom: 20),
                                          child: Text(
                                            snapshot.data![index].appliance
                                                .capitalize
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: w * 0.035,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
=======
                                              top: 5, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Model :"),
                                              Text(snapshot.data![index].model),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Category :"),
                                              Text(snapshot
                                                  .data![index].appliance),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Date :"),
                                              Text(formattedDate),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Total charge :"),
                                              Text(
                                                  snapshot.data![index].charge),
                                            ],
>>>>>>> 1f2f7913c376bb97c390e21e149e24e09f4776e3
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(
                                              "Pay",
                                              style:
                                                  TextStyle(fontSize: w * 0.04),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, right: 20, bottom: 10),
                                          child: snapshot.data![index]
                                                      .serviceStatus ==
                                                  "pending"
                                              ? Icon(
                                                  Icons.pending_actions,
                                                  color: Colors.orange,
                                                )
                                              : snapshot.data![index]
                                                          .serviceStatus ==
                                                      "in process"
                                                  ? Icon(
                                                      Icons.timelapse_outlined,
                                                      color: color.primary,
                                                    )
                                                  : Icon(Icons.done,
                                                      color: Colors.green),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20, bottom: 20),
                                          child: Text(
                                            formattedDate +
                                                " | " +
                                                formattedTime,
                                            style: TextStyle(
                                                fontSize: w * 0.035,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: newStatus == "all"
                              ? Text("You do not have any requests")
                              : Text(
                                  "You do not have any ${newStatus} requests"),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
