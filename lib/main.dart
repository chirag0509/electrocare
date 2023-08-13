import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare/components/drawer.dart';
import 'package:electrocare/forms/forgetPsk.dart';
import 'package:electrocare/forms/login.dart';
import 'package:electrocare/forms/register.dart';
import 'package:electrocare/home.dart';
import 'package:electrocare/menu/settings.dart';
import 'package:electrocare/menu/terms.dart';
import 'package:electrocare/menu/userTerms.dart';
import 'package:electrocare/repository/authentication/auth.dart';
import 'package:electrocare/repository/controller/colorController.dart';
import 'package:electrocare/repository/controller/formController.dart';
import 'package:electrocare/repository/database/firebase_options.dart';
import 'package:electrocare/routes.dart';
import 'package:electrocare/user/categories.dart';
import 'package:electrocare/user/dashboard.dart';
import 'package:electrocare/user/profile.dart';
import 'package:electrocare/user/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'forms/phone.dart';
import 'menu/about.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    Get.put(Auth());
    Get.put(FormController());
    Get.put(ColorController());
    Get.put(DrawerCom());
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final color = ColorController.instance;

  void initState() {
    checkOffer();
    super.initState();
  }

  void checkOffer() async {
    final offerDocs =
        await FirebaseFirestore.instance.collection("offers").get();
    final currentTimestamp = Timestamp.now();
    if (offerDocs.docs.isNotEmpty) {
      for (var i in offerDocs.docs) {
        Timestamp offerTimestamp = i["valid"];
        if (offerTimestamp.compareTo(currentTimestamp) < 0) {
          deleteOffer(i.id, i["image"]);
        }
      }
    }
  }

  Future<void> deleteOffer(String offerId, String imageUrl) async {
    try {
      // Delete from Firestore collection
      await FirebaseFirestore.instance
          .collection('offers')
          .doc(offerId)
          .delete();

      // Delete from Firebase Storage
      if (imageUrl.isNotEmpty) {
        final Reference storageRef =
            FirebaseStorage.instance.refFromURL(imageUrl);
        await storageRef.delete();
      }

      // Show a success message or perform any other necessary actions
    } catch (error) {
      // Handle errors
      print("Error deleting Offer: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: MaterialColor(
        color.primary.value,
        <int, Color>{
          50: color.primary.withOpacity(0.1),
          100: color.primary.withOpacity(0.2),
          200: color.primary.withOpacity(0.3),
          300: color.primary.withOpacity(0.4),
          400: color.primary.withOpacity(0.5),
          500: color.primary.withOpacity(0.6),
          600: color.primary.withOpacity(0.7),
          700: color.primary.withOpacity(0.8),
          800: color.primary.withOpacity(0.9),
          900: color.primary.withOpacity(1),
        },
      )),
      getPages: [
        GetPage(name: MyRoutes.home, page: () => Home()),
        GetPage(name: MyRoutes.register, page: () => Register()),
        GetPage(name: MyRoutes.login, page: () => Login()),
        GetPage(name: MyRoutes.phone, page: () => Phone()),
        GetPage(name: MyRoutes.forgetPsk, page: () => ForgetPsk()),
        GetPage(name: UserRoutes.dashboard, page: () => Dashboard()),
        GetPage(name: UserRoutes.categories, page: () => Categories()),
        GetPage(name: UserRoutes.profile, page: () => Profile()),
        GetPage(name: MenuRoutes.terms, page: () => Terms()),
        GetPage(name: MenuRoutes.userTerms, page: () => UserTerms()),
        GetPage(name: MenuRoutes.about, page: () => About()),
        GetPage(name: MenuRoutes.settings, page: () => SettingsPage()),
        GetPage(name: UserRoutes.services, page: () => Services()),
      ],
    );
  }
}
