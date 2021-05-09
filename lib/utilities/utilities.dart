import 'package:kku_contest_app/imports.dart';

class Utilities {
  static void changeLanguages(Languages language, context) {
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


  static String getChatRoomIdByUserNames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }

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
