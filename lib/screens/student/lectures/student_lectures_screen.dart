import 'package:flutter/material.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utilities/utilities.dart';
import 'package:kku_contest_app/widgets/student_widgets/student_widgets.dart';

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
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        brightness: AppTheme.darkTheme.appBarTheme.brightness,
        backgroundColor: AppTheme.darkTheme.backgroundColor,
        title: Text(
          widget.title.toUpperCase(),
          style: textDirection == TextDirection.ltr
              ? Utilities.getUbuntuTextStyleWithSize(16)
              : Utilities.getTajwalTextStyleWithSize(16),
        ),
      ),
      body: StudentWidgets.getStudentLectures(textDirection,widget.id),
    );
  }


}