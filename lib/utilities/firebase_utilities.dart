import 'package:connected/imports.dart';

class FirebaseUtilities {
  static String instructorNameKey = "instructor_name_key";
  static String instructorIdKey = "instructor_id_key";
  static String instructorImageKey = "instructor_image_key";

  static String userEmailKey = "user_email_key";
  static String userNameKey = "user_name_key";
  static String userImageKey = "user_image_key";
  static String userIdKey = "user_id_key";



  static Future<bool> saveInstructorName(String getInstructorName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(instructorNameKey, getInstructorName);
  }
  static Future<bool> saveInstructorID(String getInstructorID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(instructorIdKey, getInstructorID);
  }
    static Future<bool> saveInstructorImageUrl(String getInstructorImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(instructorImageKey, getInstructorImage);
  }

  static Future<String> getInstructorName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(instructorNameKey);
  }
  static Future<String> getInstructorID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(instructorIdKey);
  }
  static Future<String> getInstructorImageUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(instructorImageKey);
  }


  static Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  static Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  static Future<bool> saveUserImageUrl(String getImageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImageKey, getImageUrl);
  }

  static Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  static Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  static Future<String> getUserImageUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImageKey);
  }

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }


}
