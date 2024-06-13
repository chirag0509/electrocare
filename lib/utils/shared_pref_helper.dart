import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance =
      SharedPreferencesHelper.init();

  factory SharedPreferencesHelper() {
    return _instance;
  }

  SharedPreferencesHelper.init();

  static late SharedPreferences _prefs;

  static Future<void> onInit() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //-----------------------------------------------//

  static void clearShareCache() {
    _prefs.clear();
  }

  //-----------------------------------------------//

  static void setIsFirstTime(bool isFirstTime) {
    _prefs.setBool("isFirstTime", isFirstTime);
  }

  static bool getIsFirstTime() {
    return _prefs.getBool("isFirstTime") ?? true;
  }

  //---------------------------------------------//

  static void setIsLoggedIn(bool isLoggedIn) {
    _prefs.setBool("isLoggedIn", isLoggedIn);
  }

  static bool getIsLoggedIn() {
    return _prefs.getBool("isLoggedIn") ?? false;
  }

  //-----------------------------------------------//

  static void setIsLoginSkipped(bool isLoginSkipped) {
    _prefs.setBool("isLoginSkipped", isLoginSkipped);
  }

  static bool getIsLoginSkipped() {
    return _prefs.getBool("isLoginSkipped") ?? false;
  }

  //-----------------------------------------------//

  static void setUserId(String userId) {
    _prefs.setString("userId", userId);
  }

  static String getUserId() {
    return _prefs.getString("userId") ?? '';
  }

  //-----------------------------------------------//

  static void setEmail(String email) {
    _prefs.setString("email", email);
  }

  static String getEmail() {
    return _prefs.getString("email") ?? '';
  }

  //-----------------------------------------------//

  static void setPhone(String phone) {
    _prefs.setString("phone", phone);
  }

  static String getPhone() {
    return _prefs.getString("phone") ?? '';
  }
}
