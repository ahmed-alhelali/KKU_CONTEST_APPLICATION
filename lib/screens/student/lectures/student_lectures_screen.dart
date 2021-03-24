import 'package:flutter/material.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utilities/utilities.dart';
import 'package:kku_contest_app/widgets/student_widgets/student_widgets.dart';
import 'package:provider/provider.dart';

class StudentLectureScreen extends StatefulWidget {
  final String title;
  final String id;

  const StudentLectureScreen({Key key, this.id, this.title}) : super(key: key);

  @override
  _StudentLectureScreenState createState() => _StudentLectureScreenState();
}

class _StudentLectureScreenState extends State<StudentLectureScreen> {

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.isDarkMode ? false : true;

    return Scaffold(
      backgroundColor: isLightTheme ? AppTheme.lightTheme.scaffoldBackgroundColor : AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        brightness: isLightTheme ? AppTheme.lightTheme.appBarTheme.brightness : AppTheme.darkTheme.appBarTheme.brightness,
        backgroundColor: isLightTheme ? AppTheme.lightTheme.backgroundColor : AppTheme.darkTheme.backgroundColor,
        iconTheme: isLightTheme ? AppTheme.lightTheme.appBarTheme.iconTheme : AppTheme.darkTheme.appBarTheme.iconTheme,
        title: Text(
          widget.title.toUpperCase(),
          style: textDirection == TextDirection.ltr
              ? Utilities.getUbuntuTextStyleWithSize(16,color: themeProvider.themeColor(isLightTheme).textColor)
              : Utilities.getTajwalTextStyleWithSize(16,color: themeProvider.themeColor(isLightTheme).textColor),
        ),
      ),
      body: StudentWidgets.getStudentLectures(themeProvider, isLightTheme, textDirection,widget.id),
    );
  }



}