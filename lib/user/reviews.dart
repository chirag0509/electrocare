import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/repository/controller/colorController.dart';
import 'package:electrocare/repository/database/handleService.dart';
import 'package:electrocare/repository/models/feedbackModel.dart';
import 'package:electrocare/repository/models/serviceModel.dart';
import 'package:electrocare/repository/models/userModel.dart';
import 'package:electrocare/user/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../repository/authentication/auth.dart';

class Reviews extends StatefulWidget {
  final String appliance;
  const Reviews({Key? key, required this.appliance}) : super(key: key);

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  final color = ColorController.instance;
  final serviceController = Get.put(HandleService());

  String newStatus = "pending";

  Stream<List> getReviews() {
    return FirebaseFirestore.instance.collection("feedbacks").snapshots().map(
        (event) => event.docs
            .where((element) => element['appliance'] == widget.appliance)
            .toList());
  }

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
                  "Reviews",
                  style: TextStyle(
                    fontSize: w * 0.06,
                    fontWeight: FontWeight.w500,
                    color: color.black,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              StreamBuilder<List>(
                stream: getReviews(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.length != 0
                        ? ListView.builder(
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(snapshot.data![index]
                                                    ['email'])
                                                .snapshots(),
                                            builder: (context, imageSnapshot) {
                                              if (imageSnapshot.hasData) {
                                                return CircleAvatar(
                                                  radius: 35,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          imageSnapshot
                                                              .data!['image']),
                                                  backgroundColor:
                                                      color.secondary,
                                                );
                                              } else {
                                                return CircleAvatar(
                                                  radius: 35,
                                                  backgroundColor:
                                                      color.secondary,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                        ConstrainedBox(
                                          constraints:
                                              BoxConstraints(maxWidth: w * 0.7),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${snapshot.data![index]['name']}"
                                                    .capitalize
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: w * 0.045,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              RatingBar.builder(
                                                initialRating: snapshot
                                                    .data![index]['rating']
                                                    .toDouble(),
                                                minRating: 1,
                                                maxRating: 5,
                                                itemSize: 20,
                                                ignoreGestures: true,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                unratedColor:
                                                    Colors.grey.shade300,
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.yellow.shade800,
                                                ),
                                                onRatingUpdate: (rating) {},
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                snapshot.data![index]['review'],
                                                style: TextStyle(
                                                    fontSize: w * 0.035,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              "This item is not yet reviewed by any user",
                              style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.w400),
                            ),
                          );
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
