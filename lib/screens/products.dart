import 'package:cached_network_image/cached_network_image.dart';
import 'package:electrocare/respository/controllers/product_controller.dart';
import 'package:electrocare/respository/models/product_model.dart';
import 'package:electrocare/screens/product_detail.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Products extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const Products(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final productController = Get.put(ProductController());

  void _onSearch(String query) {
    if (query.isEmpty) {
      productController.filteredProducts.value =
          productController.products.value;
      return;
    } else {
      productController.filteredProducts.value = productController.products
          .where((e) => e.name.contains(query))
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    productController.fetchProducts(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bg1,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 60.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    radius: 21.r,
                    backgroundColor: Constants.white,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 21.sp,
                      color: Constants.black,
                    ),
                  ),
                ),
                Text(
                  "${widget.categoryName.capitalize}",
                  style: Constants.poppins(
                    20.sp,
                    FontWeight.w500,
                    Constants.black,
                  ),
                ),
                CircleAvatar(
                  radius: 21.r,
                  backgroundColor: Constants.white,
                  child: Icon(
                    FontAwesomeIcons.bell,
                    size: 21.sp,
                    color: Constants.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                  color: Constants.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    )
                  ]),
              child: TextField(
                cursorColor: Constants.primary,
                style: Constants.poppins(
                  14.sp,
                  FontWeight.w500,
                  Constants.black,
                ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(5.w),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Constants.bg1,
                      ),
                      child: Icon(
                        FontAwesomeIcons.magnifyingGlass,
                        size: 16.sp,
                        color: Constants.primary,
                      ),
                    ),
                  ),
                  suffixIcon: Icon(
                    FontAwesomeIcons.microphone,
                    size: 16.sp,
                    color: Constants.primary,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15.h,
                  ),
                  hintText: " Search Product...",
                  hintStyle: Constants.poppins(
                    14.sp,
                    FontWeight.w500,
                    Constants.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Constants.white,
                ),
                onChanged: (value) {
                  _onSearch(value);
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Obx(
                      () => GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10.w,
                          crossAxisSpacing: 10.w,
                        ),
                        itemCount: productController.filteredProducts.length,
                        itemBuilder: (context, index) {
                          final data =
                              productController.filteredProducts[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetail(
                                          category: widget.categoryName,
                                          categoryId: widget.categoryId,
                                          data: data,
                                        )),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                  color: Constants.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                    )
                                  ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 40.w,
                                    height: 40.w,
                                    child: Image(
                                      image: CachedNetworkImageProvider(
                                          data.image),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    "${data.name.capitalize}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: Constants.poppins(
                                      13.sp,
                                      FontWeight.w500,
                                      Constants.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
