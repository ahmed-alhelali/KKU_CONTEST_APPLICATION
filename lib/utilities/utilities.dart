import 'package:connected/imports.dart';

class Utilities {
  static Future<void> changeLanguages(Languages language, context) async {
    Locale _temp;
    switch (language.languageCode) {
      case 'en':
        _temp = Locale(language.languageCode, '');
        break;
      case 'ar':
        _temp = Locale(language.languageCode, '');
        break;
    }
    MyApp.setLocale(context, _temp);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("isEn", language.languageCode);
  }

  static TextStyle getTajwalTextStyleWithSize(double size,
      {FontWeight fontWeight,
      double letterSpacing,
      double height,
      Color color}) {
    return GoogleFonts.tajawal(
      fontSize: size,
      letterSpacing: letterSpacing,
      height: height,
      color: color ?? Colors.white,
      fontWeight: fontWeight,
    );
  }

  static String getRandomIdForNewCourse() {
    var uuid = Uuid();
    return uuid.v4();
  }

  static TextStyle getUbuntuTextStyleWithSize(double size,
      {FontWeight fontWeight,
      double letterSpacing,
      double height,
      Color color}) {
    return GoogleFonts.ubuntu(
      fontSize: size,
      letterSpacing: letterSpacing,
      height: height,
      color: color ?? Colors.white,
      fontWeight: fontWeight,
    );
  }
}
