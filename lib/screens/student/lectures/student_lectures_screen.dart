import 'package:flutter/material.dart';
import 'package:kku_contest_app/FirebaseAPI/firestore.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utils/utils.dart';

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
        backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: textDirection == TextDirection.ltr
              ? Utils.getUbuntuTextStyleWithSize(14)
              : Utils.getTajwalTextStyleWithSize(14),
        ),
      ),
      body: FirestoreDB.getStudentLectures(textDirection,widget.id),
    );
  }


}