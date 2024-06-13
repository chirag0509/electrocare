import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:electrocare/respository/controllers/testimonial_controller.dart';
import 'package:electrocare/respository/models/testimonial_model.dart';
import 'package:electrocare/utils/common_widgets.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Testimonials extends StatefulWidget {
  final List<Color> color;
  final List<TestimonialModel> testimonials;
  const Testimonials(
      {super.key, required this.color, required this.testimonials});

  @override
  State<Testimonials> createState() => _TestimonialsState();
}

class _TestimonialsState extends State<Testimonials> {
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;
  int count = 3;

  Widget dotIndicator() {
    int n = widget.testimonials.length;

    return DotsIndicator(
      dotsCount: n < count ? n : count,
      position: _currentIndex % count,
      decorator: DotsDecorator(
        activeColor: Constants.primary,
        color: Constants.grey,
        size: Size(8.w, 8.w),
        activeSize: Size(8.w, 8.w),
        spacing: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        categoryHeading("Testimonials"),
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: size.height * 0.24,
            enableInfiniteScroll: true,
            viewportFraction: 1,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.testimonials.map((element) {
            return SizedBox(
              width: size.width,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.h),
                      width: size.width - 40.w,
                      height: size.height * 0.21,
                      decoration: BoxDecoration(
                        color: Constants.white,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30.h,
                            ),
                            Text(
                              "${element.name.capitalize}",
                              textAlign: TextAlign.center,
                              style: Constants.poppins(
                                14.sp,
                                FontWeight.w500,
                                Constants.black,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            RatingBar(
                              alignment: Alignment.center,
                              filledIcon: Icons.star,
                              emptyIcon: Icons.star_outline,
                              onRatingChanged: (p0) {},
                              initialRating: element.rating.toDouble(),
                              isHalfAllowed: true,
                              halfFilledIcon: Icons.star_half,
                              size: 16.sp,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              element.feedback,
                              textAlign: TextAlign.center,
                              style: Constants.poppins(
                                13.sp,
                                FontWeight.w400,
                                Constants.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: (size.width - 90.w) / 2,
                    child: ClipOval(
                      child: Container(
                        color:
                            widget.color[_currentIndex % widget.color.length],
                        width: 60.w,
                        height: 60.w,
                        child: Image(
                          image: CachedNetworkImageProvider(element.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(
          height: 5.h,
        ),
        Center(child: dotIndicator()),
      ],
    );
  }
}
