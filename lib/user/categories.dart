import 'package:cached_network_image/cached_network_image.dart';
import 'package:electrocare/components/drawer.dart';
import 'package:electrocare/repository/controller/colorController.dart';
import 'package:electrocare/repository/database/handleCategories.dart';
import 'package:electrocare/user/componentDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../repository/models/componentModel.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final color = ColorController.instance;

  final categoryController = Get.put(HandleCategories());

  bool list = false;

  TextEditingController _searchController = TextEditingController();
  String _searchValue = '';
  FocusNode _focusNode = FocusNode();
  List<String> selectedComponents = [];

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
                "Categories",
                style:
                    TextStyle(fontSize: w * 0.08, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: w * 0.75,
                    child: TextFormField(
                      controller: _searchController,
                      style: TextStyle(fontSize: w * 0.045),
                      decoration: InputDecoration(
                          hintText: "Search appliances",
                          hintStyle: TextStyle(fontSize: w * 0.045),
                          filled: true,
                          fillColor: Color(0xfff3f3f3),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10))),
                      onChanged: (value) {
                        setState(() {
                          _searchValue = value;
                        });
                      },
                      focusNode: _focusNode,
                      onFieldSubmitted: (value) {
                        _focusNode.unfocus();
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          list = !list;
                        });
                      },
                      icon: list
                          ? Icon(
                              Icons.grid_view_outlined,
                              size: w * 0.075,
                            )
                          : Icon(
                              Icons.list_outlined,
                              size: w * 0.075,
                            ))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Appliances",
                style:
                    TextStyle(fontSize: w * 0.06, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<List<ComponentModel>>(
              stream: categoryController.componentsList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ComponentModel> filteredData = snapshot.data!
                      .where((element) => element.id
                          .toLowerCase()
                          .contains(_searchValue.toLowerCase()))
                      .where((element) =>
                          selectedComponents.isEmpty ||
                          selectedComponents.contains(element.id))
                      .toList();
                  return list
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                              child: InkWell(
                                onTap: () {
                                  final component = ComponentModel(
                                    id: filteredData[index].id,
                                    category: filteredData[index].category,
                                    popular: filteredData[index].popular,
                                    image: filteredData[index].image,
                                    rating: filteredData[index].rating,
                                    mrc: filteredData[index].mrc,
                                    msc: filteredData[index].msc,
                                    sc: filteredData[index].sc,
                                    dc: filteredData[index].dc,
                                  );
                                  Get.to(() =>
                                      ComponentDetail(component: component));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: color.secondary,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              height: 75,
                                              width: 75,
                                              decoration: BoxDecoration(
                                                  color: color.tertiary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: CachedNetworkImage(
                                                  imageUrl: filteredData[index]
                                                      .image),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                filteredData[index]
                                                    .id
                                                    .toString()
                                                    .capitalize
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: w * 0.04,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                filteredData[index]
                                                    .category
                                                    .capitalize
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: w * 0.03,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              RatingBar.builder(
                                                initialRating:
                                                    filteredData[index]
                                                        .rating
                                                        .toDouble(),
                                                minRating: 1,
                                                maxRating: 5,
                                                itemSize: 20,
                                                ignoreGestures: true,
                                                direction: Axis.horizontal,
                                                allowHalfRating: false,
                                                unratedColor:
                                                    Colors.grey.shade300,
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.yellow.shade800,
                                                ),
                                                onRatingUpdate: (rating) {},
                                              ),
                                            ],
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
                              ),
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                              childAspectRatio: 2 / 2.5,
                            ),
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  final component = ComponentModel(
                                    id: filteredData[index].id,
                                    category: filteredData[index].category,
                                    popular: filteredData[index].popular,
                                    image: filteredData[index].image,
                                    rating: filteredData[index].rating,
                                    mrc: filteredData[index].mrc,
                                    msc: filteredData[index].msc,
                                    sc: filteredData[index].sc,
                                    dc: filteredData[index].dc,
                                  );
                                  Get.to(() =>
                                      ComponentDetail(component: component));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color.secondary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: Container(
                                          width: 125,
                                          height: 125,
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: CachedNetworkImage(
                                              imageUrl:
                                                  filteredData[index].image),
                                        ),
                                      ),
                                      Text(
                                        filteredData[index]
                                            .id
                                            .toString()
                                            .capitalize
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: w * 0.04,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        filteredData[index]
                                            .category
                                            .capitalize
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: w * 0.03,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      RatingBar.builder(
                                        initialRating: filteredData[index]
                                            .rating
                                            .toDouble(),
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
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                } else {
                  return list
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                              childAspectRatio: 2 / 2.5,
                            ),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ));
  }
}
