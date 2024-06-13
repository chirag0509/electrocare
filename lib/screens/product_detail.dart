import 'package:cached_network_image/cached_network_image.dart';
import 'package:electrocare/respository/models/product_model.dart';
import 'package:electrocare/screens/check_availability.dart';
import 'package:electrocare/utils/common_widgets.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ProductDetail extends StatefulWidget {
  final String category;
  final String categoryId;
  final ProductModel data;
  const ProductDetail({
    super.key,
    required this.category,
    required this.categoryId,
    required this.data,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final List<List<dynamic>> _parts = [];

  final List<String> _selectedParts = [];

  bool isSelected(String data) {
    return _selectedParts.contains(data);
  }

  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.data.mrc.forEach((key, value) {
      _parts.add([key, value]);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.bg1,
      body: Stack(
        children: [
          SlidingBox(
            animationCurve: Curves.easeIn,
            physics: const BouncingScrollPhysics(),
            maxHeight: size.height * 0.55,
            minHeight: size.height * 0.55,
            backdrop: Backdrop(
              color: Constants.bg1,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 60.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
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
                            "${widget.data.name.capitalize}",
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
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      height: size.width * 0.5,
                      child: Image(
                        image: CachedNetworkImageProvider(widget.data.image),
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                  ],
                ),
              ),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              color: Constants.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter ${widget.data.name} details",
                    style: Constants.poppins(
                      18.sp,
                      FontWeight.w500,
                      Constants.black,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                    child: textField(size, _brandController, "Brand",
                        (value) {}, false, false, false),
                  ),
                  Center(
                    child: textField(size, _modelController, "Model",
                        (value) {}, false, false, false),
                  ),
                  Text(
                    "Select Repairable Part",
                    style: Constants.poppins(
                      18.sp,
                      FontWeight.w500,
                      Constants.black,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10.w,
                      crossAxisSpacing: 10.w,
                    ),
                    itemCount: _parts.length + 1,
                    itemBuilder: (context, index) {
                      if (index < _parts.length) {
                        final data = _parts[index];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!_selectedParts.contains(data[0])) {
                                _selectedParts.add(data[0]);
                              } else {
                                _selectedParts.remove(data[0]);
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                  width: 1,
                                  color: isSelected(data[0])
                                      ? Constants.primary
                                      : Colors.grey.shade400),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${data[0].toString().capitalize}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: Constants.poppins(
                                    13.sp,
                                    FontWeight.w500,
                                    isSelected(data[0])
                                        ? Constants.primary
                                        : Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  "₹ ${data[1]}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: Constants.poppins(
                                    13.sp,
                                    FontWeight.w500,
                                    isSelected(data[0])
                                        ? Constants.primary
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border:
                                Border.all(width: 1, color: Constants.primary),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Service Charge",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: Constants.poppins(
                                    13.sp, FontWeight.w500, Constants.primary),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                "₹ ${widget.data.msc.toString().capitalize}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: Constants.poppins(
                                  13.sp,
                                  FontWeight.w500,
                                  Constants.primary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Constants.bg1,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_selectedParts.length} part selected",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Constants.poppins(
                      16.sp,
                      FontWeight.w500,
                      Constants.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_brandController.text.isNotEmpty &&
                          _modelController.text.isNotEmpty &&
                          _selectedParts.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckAvailability(
                                      category: widget.category,
                                      categoryId: widget.categoryId,
                                      device: widget.data.name,
                                      deviceId: widget.data.id,
                                      brand: _brandController.text
                                          .trim()
                                          .toLowerCase(),
                                      model: _modelController.text
                                          .trim()
                                          .toLowerCase(),
                                      image: widget.data.image,
                                      selectParts: _selectedParts,
                                      serviceCharge: widget.data.msc,
                                    )));
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 20.w),
                      decoration: BoxDecoration(
                          color: _selectedParts.isEmpty ||
                                  _brandController.text.isEmpty ||
                                  _modelController.text.isEmpty
                              ? Colors.transparent
                              : Constants.black,
                          border: _selectedParts.isEmpty ||
                                  _brandController.text.isEmpty ||
                                  _modelController.text.isEmpty
                              ? Border.all(width: 1, color: Constants.grey)
                              : Border.all(width: 0),
                          borderRadius: BorderRadius.circular(50.r)),
                      child: Text(
                        "Check Availability",
                        maxLines: 2,
                        style: Constants.poppins(
                          16.sp,
                          FontWeight.w500,
                          _selectedParts.isEmpty ||
                                  _brandController.text.isEmpty ||
                                  _modelController.text.isEmpty
                              ? Constants.grey
                              : Constants.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
