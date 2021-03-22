import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kku_contest_app/FirebaseAPI/firestore.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utils/utils.dart';
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
      body: getInstructorCourses(textDirection),
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

  Widget getInstructorCourses(TextDirection textDirection) {
    CollectionReference courses = FirebaseFirestore.instance
        .collection("Courses")
        .doc(widget.id)
        .collection("lectures");

    return StreamBuilder<QuerySnapshot>(
      stream: courses.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                MyLocalization.of(context)
                    .getTranslatedValue("error_connection"),
                style: textDirection == TextDirection.ltr
                    ? Utils.getUbuntuTextStyleWithSize(14)
                    : Utils.getTajwalTextStyleWithSize(14),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data.size == 0) {
          return Center(
            child: Text(
              MyLocalization.of(context)
                  .getTranslatedValue("no_lectures_instructor"),
              style: textDirection == TextDirection.ltr
                  ? Utils.getUbuntuTextStyleWithSize(14)
                  : Utils.getTajwalTextStyleWithSize(14),
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(vertical: 6),
          children: snapshot.data.docs.map(
                (DocumentSnapshot document) {
              final titleLecture = document.get("title");
              print(titleLecture);
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      titleLecture,
                      style: textDirection == TextDirection.ltr
                          ? Utils.getUbuntuTextStyleWithSize(12)
                          : Utils.getTajwalTextStyleWithSize(12),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 25,
                      ),
                      onPressed: () {
                        InstructorFirestoreDB.deleteLecture( widget.id , titleLecture);
                        // deleteLecture(titleLecture);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 0.5,
                      child: Container(
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        );
      },
    );
  }



}
