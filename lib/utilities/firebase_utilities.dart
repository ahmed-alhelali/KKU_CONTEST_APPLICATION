import 'package:shared_preferences/shared_preferences.dart';

class FirebaseUtilities {
  static String userEmailKey = "USEREMAILKEY";
  static String userIdKey = "USERKEY";

  static Future<bool> saveUserEmail(String getUseremail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUseremail);
  }

  static Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  static Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }
}
