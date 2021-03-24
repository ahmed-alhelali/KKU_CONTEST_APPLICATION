import 'package:flutter/material.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class HelpStudentScreen extends StatefulWidget {
  @override
  _HelpStudentScreenState createState() => _HelpStudentScreenState();
}

class _HelpStudentScreenState extends State<HelpStudentScreen> {
  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.isDarkMode ? false : true;

    return Scaffold(
      backgroundColor: isLightTheme
          ? AppTheme.lightTheme.scaffoldBackgroundColor
          : AppTheme.darkTheme.scaffoldBackgroundColor,
      body: Center(
        child: Text(
          MyLocalization.of(context).getTranslatedValue("no_student_ask_help"),
          style: textDirection == TextDirection.ltr
              ? Utilities.getUbuntuTextStyleWithSize(14,
                  color: themeProvider.themeColor(isLightTheme).textColor)
              : Utilities.getTajwalTextStyleWithSize(14,
                  color: themeProvider.themeColor(isLightTheme).textColor),
        ),
      ),
    );
  }
}
