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


  static Padding getContainerWithOnOnTap(Icon icon, String keyMap,
      TextDirection textDirection, BuildContext context,
      {Function onTap}) {
    return Padding(
      padding: textDirection == TextDirection.ltr ?EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.60,
      ) :EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.60,
      ),
      child: InkWell(
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.darkTheme.scaffoldBackgroundColor,
              borderRadius: textDirection == TextDirection.ltr
                  ? BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
              )
                  : BorderRadius.only(
                topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
            ),
            width: 150,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  icon,
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    MyLocalization.of(context).getTranslatedValue(keyMap),
                    style: textDirection == TextDirection.ltr
                        ? Utils.getUbuntuTextStyleWithSize(13)
                        : Utils.getTajwalTextStyleWithSize(13),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  static showWarringDialog(
      String keyTitle,
      String keyContent,
      BuildContext context,
      String yetText,
      String noText,
      Function functionOfYesButton,
      Function functionOfNoButton,
      TextDirection textDirection,
      ) {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      title: Text(
        MyLocalization.of(context).getTranslatedValue(keyTitle),
        style: textDirection == TextDirection.ltr
            ? getUbuntuTextStyleWithSize(20)
            : getTajwalTextStyleWithSize(20),
      ),
      content: Text(
        MyLocalization.of(context).getTranslatedValue(keyContent),
        style: textDirection == TextDirection.ltr
            ? getUbuntuTextStyleWithSize(14)
            : getTajwalTextStyleWithSize(14),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            elevation: 0,
            backgroundColor: HexColor("#5C704D"),
          ),
          child: Text(
            MyLocalization.of(context).getTranslatedValue(noText),
            style: textDirection == TextDirection.ltr
                ? getUbuntuTextStyleWithSize(12)
                : getTajwalTextStyleWithSize(12),
          ),
          onPressed: functionOfNoButton,
        ),
        TextButton(
          style: TextButton.styleFrom(
            elevation: 0,
            backgroundColor: HexColor("#A74552"),
          ),
          child: Text(
            MyLocalization.of(context).getTranslatedValue(yetText),
            style: textDirection == TextDirection.ltr
                ? getUbuntuTextStyleWithSize(12)
                : getTajwalTextStyleWithSize(12),
          ),
          onPressed: functionOfYesButton,
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (context) => alertDialog,
    );
  }

  static getTextFormField(TextDirection textDirection,BuildContext context,hintKey,TextEditingController controller,double borderRadius){
    return TextFormField(
      controller: controller,
      style: textDirection == TextDirection.ltr
          ? Utils.getUbuntuTextStyleWithSize(14)
          : Utils.getTajwalTextStyleWithSize(14),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.grey)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.red),
        ),
        hintText:
        MyLocalization.of(context).getTranslatedValue(hintKey),
        hintStyle: textDirection == TextDirection.ltr
            ? Utils.getUbuntuTextStyleWithSize(12)
            : Utils.getTajwalTextStyleWithSize(12),
      ),
    );
  }
}
