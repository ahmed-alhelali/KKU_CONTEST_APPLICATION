import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/main.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/models/languages.dart';

class Utils {
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
      {FontWeight fontWeight, double letterSpacing, double height,Color color}) {
    return GoogleFonts.tajawal(
      fontSize: size,
      letterSpacing: letterSpacing,
      height: height,
      color: color?? Colors.white,
      fontWeight: fontWeight,
    );
  }

  static TextStyle getUbuntuTextStyleWithSize(double size,
      {FontWeight fontWeight, double letterSpacing, double height,Color color}) {
    return GoogleFonts.ubuntu(
      fontSize: size,
      letterSpacing: letterSpacing,
      height: height,
      color: color?? Colors.white,
      fontWeight: fontWeight,
    );
  }
}
