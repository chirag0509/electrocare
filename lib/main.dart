import 'package:electrocare/components/drawer.dart';
import 'package:electrocare/forms/forgetPsk.dart';
import 'package:electrocare/forms/login.dart';
import 'package:electrocare/forms/register.dart';
import 'package:electrocare/home.dart';
import 'package:electrocare/repository/authentication/auth.dart';
import 'package:electrocare/repository/controller/colorController.dart';
import 'package:electrocare/repository/controller/formController.dart';
import 'package:electrocare/repository/database/firebase_options.dart';
import 'package:electrocare/routes.dart';
import 'package:electrocare/user/categories.dart';
import 'package:electrocare/user/dashboard.dart';
import 'package:electrocare/user/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'forms/phone.dart';

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

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final color = ColorController.instance;

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
      ],
    );
  }
}
