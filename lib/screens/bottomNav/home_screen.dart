import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/respository/controllers/auth_controller.dart';
import 'package:electrocare/respository/controllers/category_controller.dart';
import 'package:electrocare/respository/controllers/offer_controller.dart';
import 'package:electrocare/respository/controllers/plan_controller.dart';
import 'package:electrocare/respository/controllers/product_controller.dart';
import 'package:electrocare/respository/controllers/technician_controller.dart';
import 'package:electrocare/respository/controllers/testimonial_controller.dart';
import 'package:electrocare/respository/controllers/transaction_controller.dart';
import 'package:electrocare/respository/controllers/user_controller.dart';
import 'package:electrocare/respository/models/plan_model.dart';
import 'package:electrocare/respository/models/transaction_model.dart';
import 'package:electrocare/screens/components/testimonials.dart';
import 'package:electrocare/screens/products.dart';
import 'package:electrocare/utils/common_widgets.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:electrocare/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final offerController = Get.put(OfferController());
  final categoryController = Get.put(CategoryController());
  final technicianController = Get.put(TechnicianController());
  final planController = Get.put(PlanController());
  final testimonialController = Get.put(TestimonialController());
  final productController = Get.put(ProductController());
  final authController = Get.put(AuthController());
  final userController = Get.put(UserController());
  final transactionController = Get.put(TransactionController());

  List<Color> color = [
    Colors.red.withOpacity(0.5),
    Colors.orange.withOpacity(0.5),
    Colors.yellow.withOpacity(0.5),
    Colors.green.withOpacity(0.5),
    Colors.blue.withOpacity(0.5),
    Colors.indigo.withOpacity(0.5),
    Colors.purple.withOpacity(0.5),
  ];

  List<Color> planColor = [
    const Color(0xFF3498DB),
    const Color(0xFFFFD700),
    const Color(0xFF8A2BE2),
  ];

  String successDescription = "account upgraded";
  String failedDescription = "failed to upgrade account";

  void upgradeAccount(PlanModel element) async {
    int discount = (userController.plan["pricePaid"] / 2).round();

    int amount = element.price - discount;

    List<String> parts = SharedPreferencesHelper.getEmail().split("@");

    String receiptId =
        "${parts[0]}_${(transactionController.transactions.length + 1)}";

    await transactionController.createOrder(
      "upgrade account",
      amount,
      receiptId,
      (PaymentSuccessResponse response) async {
        final transaction = TransactionModel(
          orderId: response.orderId!,
          description: successDescription,
          requestId: "",
          amount: amount,
          type: "debit",
          status: "success",
          userId: SharedPreferencesHelper.getUserId(),
          createdAt: Timestamp.now(),
        );

        await transactionController.addTransaction(transaction);
        await userController.updatePlan(element.id, element.price,
            element.cashback, element.serviceDiscount, element.repairDiscount);
        await planController.fetchPlans(amount);
        await userController.getUserDetails(SharedPreferencesHelper.getEmail());
      },
      (PaymentFailureResponse response) async {
        final transaction = TransactionModel(
          orderId: response.error!["metadata"]["order_id"],
          description: failedDescription,
          requestId: "",
          amount: amount,
          type: "debit",
          status: "failure",
          userId: SharedPreferencesHelper.getUserId(),
          createdAt: Timestamp.now(),
        );

        await transactionController.addTransaction(transaction);
      },
    );
  }

  void _initPrefs() async {
    bool? isActive = await userController.getUserStatus();

    if (isActive != null && !isActive) {
      await authController.logout();
    }

    await userController.getUserDetails(SharedPreferencesHelper.getEmail());
    await userController.getUserLocation();
    await offerController.fetchOffers();
    await categoryController.fetchCategories();
    await technicianController.fetchTechnicians();
    await planController.fetchPlans(userController.plan["pricePaid"]);
    await testimonialController.fetchTestimonials();
  }

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      color: Constants.bg1,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(
            height: 60.h,
          ),
          Row(
            children: [
              Obx(
                () => userController.image.isEmpty
                    ? CircleAvatar(
                        radius: 23.r,
                        backgroundColor: Constants.white,
                        child: SvgPicture.asset(
                          "assets/avatar.svg",
                          width: 23.w,
                        ),
                      )
                    : ClipOval(
                        child: Container(
                          width: 46.w,
                          height: 46.w,
                          color: Constants.white,
                          child: Image(
                            image: CachedNetworkImageProvider(
                                userController.image.value),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
              SizedBox(
                width: 8.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      authController.isLoggedIn.value
                          ? "${userController.firstName.value.capitalize} ${userController.lastName.value.capitalize}"
                          : "User",
                      style: Constants.poppins(
                        20.sp,
                        FontWeight.w500,
                        Constants.black,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Constants.grey,
                        size: 14.sp,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Obx(
                        () => Text(
                          authController.isLoggedIn.value
                              ? "${userController.city.value.capitalize}, ${userController.state.value.capitalize}"
                              : "Location",
                          style: Constants.poppins(
                            14.sp,
                            FontWeight.w500,
                            Constants.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
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
            height: 20.h,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  categoryHeading("Welcome to Electrocare"),
                  Obx(() => CarouselSlider(
                        options: CarouselOptions(
                          height: size.height * 0.22,
                          enableInfiniteScroll: true,
                          viewportFraction: 1,
                          autoPlay: true,
                          enlargeCenterPage: true,
                        ),
                        items: offerController.offers.map((element) {
                          return SizedBox(
                            width: size.width,
                            height: size.height * 0.22,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: size.width - 40.w,
                                    height: size.height * 0.19,
                                    padding: EdgeInsets.only(
                                        left: 15.w,
                                        top: 10.h,
                                        bottom: 15.h,
                                        right: size.width * 0.4),
                                    decoration: BoxDecoration(
                                      color: Constants.secondary,
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          element.discount.toUpperCase(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Constants.poppins(
                                            24.sp,
                                            FontWeight.w500,
                                            Constants.white,
                                          ),
                                        ),
                                        Text(
                                          element.offer,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Constants.poppins(
                                            14.sp,
                                            FontWeight.w500,
                                            Constants.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          "Valid until ${formattedDate("${element.validity.toDate()}")}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Constants.poppins(
                                            14.sp,
                                            FontWeight.w500,
                                            Constants.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.h, horizontal: 16.w),
                                          decoration: BoxDecoration(
                                              color: Constants.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.r)),
                                          child: Text(
                                            "Book Now",
                                            style: Constants.poppins(
                                              14.sp,
                                              FontWeight.w500,
                                              Constants.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 10.w,
                                  bottom: 0,
                                  child: SizedBox(
                                    height: size.height * 0.22,
                                    child: Image(
                                      image: CachedNetworkImageProvider(
                                          element.image),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )),
                  SizedBox(
                    height: 15.h,
                  ),
                  categoryHeading("Categories"),
                  SizedBox(
                    height: 15.h,
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
                      itemCount: categoryController.categories.length,
                      itemBuilder: (context, index) {
                        final data = categoryController.categories[index];

                        return GestureDetector(
                          onTap: () {
                            productController.products.clear();
                            productController.filteredProducts.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Products(
                                      categoryId: data.id,
                                      categoryName: data.name)),
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
                                    image:
                                        CachedNetworkImageProvider(data.image),
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
                    height: 15.h,
                  ),
                  categoryHeading("Top-Rated Technicians"),
                  SizedBox(
                    height: 15.h,
                  ),
                  Obx(
                    () => SizedBox(
                      height: size.height * 0.16,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: technicianController.technicians.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 10.w,
                          );
                        },
                        itemBuilder: (context, index) {
                          final data = technicianController.technicians[index];
                          return Container(
                            width: size.width * 0.23,
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 10.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  width: 1,
                                  color: color[index % color.length],
                                )),
                            child: Column(
                              children: [
                                ClipOval(
                                  child: Container(
                                    color: Constants.white,
                                    width: 50.w,
                                    height: 50.w,
                                    child: Image(
                                      image: CachedNetworkImageProvider(
                                          data.image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Constants.orange,
                                      size: 20.sp,
                                    ),
                                    Text(
                                      "${data.rating}",
                                      style: Constants.poppins(
                                        14.sp,
                                        FontWeight.w500,
                                        Constants.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "${data.firstName.capitalize}\n${data.lastName.capitalize}",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: Constants.poppins(
                                    13.sp,
                                    FontWeight.w500,
                                    Constants.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  categoryHeading("Service Plans"),
                  SizedBox(
                    height: 15.h,
                  ),
                  Obx(
                    () => CarouselSlider(
                      options: CarouselOptions(
                        height: size.height * 0.26,
                        enableInfiniteScroll: true,
                        viewportFraction: 1,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                      items: planController.plans.map((element) {
                        return Container(
                          width: size.width,
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 15.w),
                          decoration: BoxDecoration(
                            color: Constants.white,
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              width: 1,
                              color: planColor[element.order],
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.5,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${element.id.capitalize}",
                                        style: Constants.poppins(
                                          18.sp,
                                          FontWeight.w600,
                                          planColor[element.order],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        "Benefits",
                                        style: Constants.poppins(
                                          14.sp,
                                          FontWeight.w500,
                                          Constants.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      ...List.generate(element.benefits.length,
                                          (index) {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              " - ",
                                              style: Constants.poppins(
                                                13.sp,
                                                FontWeight.w400,
                                                Constants.black,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "${element.benefits[index]}",
                                                style: Constants.poppins(
                                                  13.sp,
                                                  FontWeight.w400,
                                                  Constants.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Validity",
                                      style: Constants.poppins(
                                        14.sp,
                                        FontWeight.w500,
                                        Constants.black,
                                      ),
                                    ),
                                    Text(
                                      "${element.validity.capitalize}",
                                      style: Constants.poppins(
                                        20.sp,
                                        FontWeight.w600,
                                        planColor[element.order],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    if (userController.plan["pricePaid"] > 0)
                                      Text(
                                        "₹ ${element.price - (userController.plan["pricePaid"] / 2).round()}/-",
                                        style: Constants.poppins(
                                          16.sp,
                                          FontWeight.w500,
                                          Constants.black,
                                        ),
                                      ),
                                    userController.plan["pricePaid"] > 0
                                        ? Text(
                                            "₹ ${element.price}/-",
                                            style: Constants.poppins(
                                              10.sp,
                                              FontWeight.w500,
                                              Constants.black,
                                            ).copyWith(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          )
                                        : Text(
                                            "₹ ${element.price}/-",
                                            style: Constants.poppins(
                                              16.sp,
                                              FontWeight.w500,
                                              Constants.black,
                                            ),
                                          ),
                                    Text(
                                      "only",
                                      style: Constants.poppins(
                                        16.sp,
                                        FontWeight.w500,
                                        Constants.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        upgradeAccount(element);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.h, horizontal: 16.w),
                                        decoration: BoxDecoration(
                                            color: planColor[element.order],
                                            borderRadius:
                                                BorderRadius.circular(8.r)),
                                        child: Text(
                                          "Upgrade",
                                          style: Constants.poppins(
                                            14.sp,
                                            FontWeight.w500,
                                            Constants.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Obx(
                    () => Testimonials(
                      color: color,
                      testimonials: testimonialController.testimonials.value,
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
    );
  }
}
