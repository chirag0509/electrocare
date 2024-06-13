import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:electrocare/respository/connection/firebase_options.dart';
import 'package:electrocare/respository/controllers/auth_controller.dart';
import 'package:electrocare/respository/transactions/razorpay_payment.dart';
import 'package:electrocare/screens/bottomNav/bottom_nav.dart';
import 'package:electrocare/screens/forms/login.dart';
import 'package:electrocare/screens/forms/reset_pass.dart';
import 'package:electrocare/screens/forms/resigter.dart';
import 'package:electrocare/screens/onboarding.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:electrocare/utils/shared_pref_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPrefs();
  runApp(const MyApp());
}

Location location = Location();
LocationData? locationData;

Future<void> initPrefs() async {
  await SharedPreferencesHelper.onInit();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  locationData = await location.getLocation();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authController = Get.put(AuthController());

  // initialize deep link
  Future<void> initUniLinks() async {
    try {
      final initialLink = await getInitialLink();

      if (initialLink != null) {
        handleDeepLink(initialLink);

        // linkStream.listen((String? link) {
        //   handleDeepLink(link);
        // });
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // handle deep link
  void handleDeepLink(String? link) async {
    if (link != null) {
      Uri uri = Uri.parse(link);
      if (uri.queryParameters.containsKey("oobCode")) {
        String oobCode = uri.queryParameters["oobCode"]!;

        Get.to(ResetPass(oobCode: oobCode));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initUniLinks();
    razorpayPayment.onPaymentSuccess();
    razorpayPayment.onPaymentError();
    razorpayPayment.onExternalWallet();
  }

  @override
  void dispose() {
    super.dispose();
    razorpayPayment.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(432, 894),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        Size size = MediaQuery.of(context).size;

        return GetMaterialApp(
          title: 'Electrocare',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Constants.primary,
            colorScheme: ColorScheme.fromSeed(seedColor: Constants.white),
            useMaterial3: false,
          ),
          home: Scaffold(
            body: DoubleBackToCloseApp(
              snackBar: SnackBar(
                backgroundColor: Constants.white,
                shape: ShapeBorder.lerp(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  const StadiumBorder(),
                  0.2,
                )!,
                width: size.width * 0.7,
                behavior: SnackBarBehavior.floating,
                content: Text(
                  'Double back to exit app',
                  textAlign: TextAlign.center,
                  style: Constants.poppins(
                      14.sp, FontWeight.w400, Constants.primary),
                ),
                duration: const Duration(seconds: 1),
              ),
              child: Obx(
                () => authController.isFirstTime.value
                    ? Onboarding()
                    : authController.isLoggedIn.value ||
                            authController.isLoginSkipped.value
                        ? const BottomNav()
                        : const LoginScreen(),
              ),
            ),
          ),
        );
      },
    );
  }
}
