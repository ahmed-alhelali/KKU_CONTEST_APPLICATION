import 'package:flutter/material.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utils/utils.dart';


class HelpStudentScreen extends StatefulWidget {
  @override
  _HelpStudentScreenState createState() => _HelpStudentScreenState();
}

class _HelpStudentScreenState extends State<HelpStudentScreen> {
  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: Center(
        child: Text(
          MyLocalization.of(context).getTranslatedValue("no_student_ask_help"),
          style: textDirection == TextDirection.ltr
              ? Utils.getUbuntuTextStyleWithSize(14)
              : Utils.getTajwalTextStyleWithSize(14),
        ),
      ),
    );
  }
}
