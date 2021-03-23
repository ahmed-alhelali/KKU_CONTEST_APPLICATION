import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kku_contest_app/FirebaseAPI/firestore.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utils/utils.dart';
import 'package:kku_contest_app/widgets/widgets.dart';
import 'create_lecture_steps.dart';

class InstructorLecturesScreen extends StatefulWidget {
  final String id;

  const InstructorLecturesScreen({Key key, this.id}) : super(key: key);

  @override
  _InstructorLecturesScreenState createState() =>
      _InstructorLecturesScreenState();
}

class _InstructorLecturesScreenState extends State<InstructorLecturesScreen> {
  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: Widgets.getInstructorLectures(textDirection,widget.id),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(6),
        child: FloatingActionButton(
          highlightElevation: 0,
          elevation: 0,
          backgroundColor: Colors.green.shade800,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateLectureSteps(widget.id),
              ),
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 45,
          ),
        ),
      ),
    );
  }
}