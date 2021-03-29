import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/models/languages.dart';
import 'package:kku_contest_app/utilities/utilities.dart';

class Widgets {
  static changeLanguageWidget(ThemeProvider themeProvider, bool isLightTheme,
      TextDirection textDirection, BuildContext context) {
    showModalBottomSheet(
      context: context,
      elevation: 10,
      barrierColor: isLightTheme ? Colors.black54 : Colors.white10,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: isLightTheme
          ? AppTheme.lightTheme.scaffoldBackgroundColor
          : AppTheme.darkTheme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              textDirection == TextDirection.ltr
                  ? Positioned(
                      right: 40,
                      bottom: MediaQuery.of(context).size.height * 0.2,
                      child: Icon(
                        FontAwesomeIcons.language,
                        color: themeProvider.themeColor(isLightTheme).textColor,
                        size: 35,
                      ),
                    )
                  : Positioned(
                      left: 40,
                      bottom: MediaQuery.of(context).size.height * 0.2,
                      child: Icon(
                        FontAwesomeIcons.language,
                        color: themeProvider.themeColor(isLightTheme).textColor,
                        size: 35,
                      ),
                    ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: 150,
                      height: 4,
                      decoration: BoxDecoration(
                        color: themeProvider.themeColor(isLightTheme).textColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    Text(
                      MyLocalization.of(context)
                          .getTranslatedValue("app_language")
                          .toUpperCase(),
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(16,
                              letterSpacing: 1,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                              color: themeProvider
                                  .themeColor(isLightTheme)
                                  .textColor)
                          : Utilities.getTajwalTextStyleWithSize(16,
                              letterSpacing: 1,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                              color: themeProvider
                                  .themeColor(isLightTheme)
                                  .textColor),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 3),
                            child: SizedBox(
                              width: 90,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.grey,
                                  elevation: 0,
                                  backgroundColor: textDirection ==
                                          TextDirection.ltr
                                      ? isLightTheme
                                          ? Colors.grey.shade200
                                          : AppTheme.darkTheme.backgroundColor
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  'English',
                                  style: textDirection == TextDirection.ltr
                                      ? Utilities.getUbuntuTextStyleWithSize(16,
                                          letterSpacing: 1,
                                          height: 1.2,
                                          fontWeight: FontWeight.bold,
                                          color: themeProvider
                                              .themeColor(isLightTheme)
                                              .textColor)
                                      : Utilities.getTajwalTextStyleWithSize(16,
                                          letterSpacing: 1,
                                          height: 1.2,
                                          fontWeight: FontWeight.bold,
                                          color: themeProvider
                                              .themeColor(isLightTheme)
                                              .textColor),
                                ),
                                onPressed: () {
                                  Utilities.changeLanguages(
                                    Languages(0, 'English', 'en'),
                                    context,
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 3),
                            child: SizedBox(
                              width: 90,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    primary: Colors.grey,
                                    elevation: 0,
                                    backgroundColor:
                                        textDirection == TextDirection.ltr
                                            ? Colors.transparent
                                            : isLightTheme
                                                ? Colors.grey.shade200
                                                : AppTheme
                                                    .darkTheme.backgroundColor),
                                child: Text(
                                  'عربي',
                                  style: textDirection == TextDirection.ltr
                                      ? Utilities.getUbuntuTextStyleWithSize(16,
                                          letterSpacing: 1,
                                          height: 1.2,
                                          fontWeight: FontWeight.bold,
                                          color: themeProvider
                                              .themeColor(isLightTheme)
                                              .textColor)
                                      : Utilities.getTajwalTextStyleWithSize(16,
                                          letterSpacing: 1,
                                          height: 1.2,
                                          fontWeight: FontWeight.bold,
                                          color: themeProvider
                                              .themeColor(isLightTheme)
                                              .textColor),
                                ),
                                onPressed: () {
                                  Utilities.changeLanguages(
                                    Languages(1, 'عربي', 'ar'),
                                    context,
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
        );
      },
    );
  }

  static Widget getContainerWithOnOnTap(
      ThemeProvider themeProvider,
      bool isLightTheme,
      Icon icon,
      String keyMap,
      TextDirection textDirection,
      BuildContext context,
      {Function onTap}) {
    return Padding(
      padding: textDirection == TextDirection.ltr
          ? EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.60,
            )
          : EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.60,
            ),
      child: InkWell(
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isLightTheme
                  ? AppTheme.lightTheme.scaffoldBackgroundColor
                  : AppTheme.darkTheme.scaffoldBackgroundColor,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  icon,
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    MyLocalization.of(context).getTranslatedValue(keyMap),
                    style: textDirection == TextDirection.ltr
                        ? Utilities.getUbuntuTextStyleWithSize(13,
                            color: themeProvider
                                .themeColor(isLightTheme)
                                .textColor)
                        : Utilities.getTajwalTextStyleWithSize(13,
                            color: themeProvider
                                .themeColor(isLightTheme)
                                .textColor),
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
    ThemeProvider themeProvider,
    bool isLightTheme,
    String keyTitle,
    String keyContent,
    BuildContext context,
    String yetText,
    String noText,
    TextDirection textDirection, {
    Function functionOfYesButton,
    Function functionOfNoButton,
  }) {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      backgroundColor: isLightTheme
          ? AppTheme.lightTheme.scaffoldBackgroundColor
          : AppTheme.darkTheme.scaffoldBackgroundColor,
      title: Text(
        MyLocalization.of(context).getTranslatedValue(keyTitle),
        style: textDirection == TextDirection.ltr
            ? Utilities.getUbuntuTextStyleWithSize(20,
                color: themeProvider.themeColor(isLightTheme).textColor)
            : Utilities.getTajwalTextStyleWithSize(20,
                color: themeProvider.themeColor(isLightTheme).textColor),
      ),
      content: Text(
        MyLocalization.of(context).getTranslatedValue(keyContent),
        style: textDirection == TextDirection.ltr
            ? Utilities.getUbuntuTextStyleWithSize(14,
                color: themeProvider.themeColor(isLightTheme).textColor,
                height: 1.5)
            : Utilities.getTajwalTextStyleWithSize(14,
                color: themeProvider.themeColor(isLightTheme).textColor),
      ),
      actions: [
        functionOfNoButton == null
            ? Container()
            : TextButton(
                style: TextButton.styleFrom(
                  elevation: 0,
                  backgroundColor: HexColor("#5C704D"),
                ),
                child: Text(
                  MyLocalization.of(context).getTranslatedValue(noText),
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(12)
                      : Utilities.getTajwalTextStyleWithSize(12),
                ),
                onPressed: functionOfNoButton,
              ),
        functionOfYesButton == null
            ? Container()
            : TextButton(
                style: TextButton.styleFrom(
                  elevation: 0,
                  backgroundColor: HexColor("#A74552"),
                ),
                child: Text(
                  MyLocalization.of(context).getTranslatedValue(yetText),
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(12)
                      : Utilities.getTajwalTextStyleWithSize(12),
                ),
                onPressed: functionOfYesButton,
              ),
      ],
    );

    showDialog(
      context: context,
      barrierColor: isLightTheme ? Colors.black54 : Colors.white10,
      builder: (context) => alertDialog,
    );
  }

  static getDialogToAskIfNeedMoreSteps(
    ThemeProvider themeProvider,
    bool isLightTheme,
    List titles,
    String keyTitle,
    BuildContext context,
    String yetText,
    String noText,
    TextDirection textDirection,
    Function functionOfYesButton,
    Function functionOfNoButton,
  ) {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      backgroundColor: isLightTheme
          ? AppTheme.lightTheme.scaffoldBackgroundColor
          : AppTheme.darkTheme.scaffoldBackgroundColor,
      title: Text(
        MyLocalization.of(context).getTranslatedValue(keyTitle),
        style: textDirection == TextDirection.ltr
            ? Utilities.getUbuntuTextStyleWithSize(16,
                color: themeProvider.themeColor(isLightTheme).textColor)
            : Utilities.getTajwalTextStyleWithSize(16,
                color: themeProvider.themeColor(isLightTheme).textColor),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: titles
                .map((e) => Column(
                      children: [
                        Text(
                          e,
                          style: textDirection == TextDirection.ltr
                              ? Utilities.getUbuntuTextStyleWithSize(12,
                                  color: isLightTheme
                                      ? Colors.black
                                      : Colors.white)
                              : Utilities.getTajwalTextStyleWithSize(12,
                                  color: isLightTheme
                                      ? Colors.black
                                      : Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ))
                .toList(),
          ),
        ),
      ),
      actions: [
        functionOfNoButton == null
            ? Container()
            : TextButton(
                style: TextButton.styleFrom(
                  elevation: 0,
                  backgroundColor: HexColor("#5C704D"),
                ),
                child: Text(
                  MyLocalization.of(context).getTranslatedValue(noText),
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(12)
                      : Utilities.getTajwalTextStyleWithSize(12),
                ),
                onPressed: functionOfNoButton,
              ),
        functionOfYesButton == null
            ? Container()
            : TextButton(
                style: TextButton.styleFrom(
                  elevation: 0,
                  backgroundColor: HexColor("#A74552"),
                ),
                child: Text(
                  MyLocalization.of(context).getTranslatedValue(yetText),
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(12)
                      : Utilities.getTajwalTextStyleWithSize(12),
                ),
                onPressed: functionOfYesButton,
              ),
      ],
    );

    showDialog(
      context: context,
      barrierColor: isLightTheme ? Colors.black54 : Colors.white10,
      builder: (context) => alertDialog,
    );
  }
}
