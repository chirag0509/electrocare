import 'package:cached_network_image/cached_network_image.dart';
import 'package:electrocare/components/drawer.dart';
import 'package:electrocare/repository/controller/colorController.dart';
import 'package:electrocare/repository/database/handleCategories.dart';
import 'package:electrocare/repository/database/handleOffer.dart';
import 'package:electrocare/repository/models/componentModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final color = ColorController.instance;

  final offerController = Get.put(HandleOffer());
  final categoryController = Get.put(HandleCategories());

  int selectedCategoryIndex = 0;

  String category = "popular";

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      backgroundColor: color.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: color.black, size: w * 0.075),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(Icons.shopping_cart_outlined),
          )
        ],
      ),
      drawer: DrawerCom.instance.drawer,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "What's broken?",
                style:
                    TextStyle(fontSize: w * 0.08, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: TextFormField(
                style: TextStyle(fontSize: w * 0.045),
                decoration: InputDecoration(
                    hintText: "Search appliances",
                    hintStyle: TextStyle(fontSize: w * 0.045),
                    filled: true,
                    fillColor: Color(0xfff3f3f3),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Offers",
                style:
                    TextStyle(fontSize: w * 0.06, fontWeight: FontWeight.w500),
              ),
            ),
            StreamBuilder(
              stream: offerController.getOffers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: h * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 20),
                            child: Container(
                              width: w * 0.42,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.5),
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.5),
                                  ],
                                  stops: const [0.4, 0.5, 0.6],
                                ),
                              ),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                direction: ShimmerDirection.ltr,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  List<Color> colors = [
                    Color(0xFFCAE9F1),
                    Color(0xFFD1D4FA),
                    Color(0xFFF3E1F7)
                  ];
                  return SizedBox(
                    height: h * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Color color = colors[index % colors.length];
                          DateTime validDate =
                              snapshot.data![index]['valid'].toDate();
                          String formattedDate =
                              DateFormat.MMMM().format(validDate) +
                                  ' ' +
                                  DateFormat.d().format(validDate);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 20),
                            child: Container(
                              width: w * 0.42,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25, left: 20),
                                    child: Text("Valid until $formattedDate"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 50, top: 10),
                                    child: Text(
                                      snapshot.data![index]['offer'],
                                      style: TextStyle(
                                        fontSize: w * 0.04,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data![index]
                                              ['image'],
                                          width: w * 0.23,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text('No data available'),
                  );
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "We can fix it",
                style:
                    TextStyle(fontSize: w * 0.06, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: categoryController.getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      height: 55,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      height: 55,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedCategoryIndex = index;
                                  category = snapshot.data!.elementAt(index);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedCategoryIndex == index
                                      ? color.black
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Center(
                                    child: Text(
                                      "${snapshot.data!.elementAt(index)}"
                                          .capitalize
                                          .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: selectedCategoryIndex == index
                                            ? color.white
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text('No data available'),
                  );
                }
              },
            ),
            StreamBuilder<List<ComponentModel>>(
              stream: categoryController.getComponents(category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: color.secondary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: color.tertiary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data![index].image,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    snapshot.data![index].id
                                        .toString()
                                        .capitalize
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: w * 0.04,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('No data available'),
                  );
                }
              },
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    ));
  }
}
