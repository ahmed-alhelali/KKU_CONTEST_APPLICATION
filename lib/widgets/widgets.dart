import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kku_contest_app/FirebaseAPI/firestore.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/screens/student/lectures/student_lecture_steps.dart';
import 'package:kku_contest_app/screens/student/lectures/student_lectures_screen.dart';
import 'package:kku_contest_app/utils/utils.dart';

class Widgets{


  static Widget getStudentCourses(TextDirection textDirection) {
    CollectionReference courses =
    FirebaseFirestore.instance.collection("Courses");
    String courseID;
    return StreamBuilder<QuerySnapshot>(
      stream: courses.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(
            MyLocalization.of(context).getTranslatedValue("error_connection"),
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
              MyLocalization.of(context).getTranslatedValue("no_courses"),
              style: textDirection == TextDirection.ltr
                  ? Utils.getUbuntuTextStyleWithSize(14)
                  : Utils.getTajwalTextStyleWithSize(14),
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(vertical: 6),
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            final currentCourse = document.data().values;
            return InkWell(
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                padding: EdgeInsets.symmetric(horizontal: 30),
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.09,
                decoration: BoxDecoration(
                  color: AppTheme.darkTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  currentCourse.first,
                  style: textDirection == TextDirection.ltr
                      ? Utils.getUbuntuTextStyleWithSize(16)
                      : Utils.getTajwalTextStyleWithSize(16),
                ),
              ),
              onTap: () {
                courseID = document.id;
                print(courseID);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentLectureScreen(
                      id: courseID,
                      title: currentCourse.first,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  static Widget getStudentLectures(TextDirection textDirection,courseID) {
    CollectionReference courses = FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
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
                  .getTranslatedValue("no_lectures_student"),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return StudentLectureSteps(
                              courseID,
                              titleLecture,
                            );
                          },
                        ),
                      );
                    },
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


  static Widget getInstructorLectures(TextDirection textDirection,courseID) {
    CollectionReference courses = FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
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
                        FirestoreDB.deleteAllSteps(courseID,titleLecture);
                        FirestoreDB.deleteAllStepsUnderLecture(
                            courseID, titleLecture);
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
            ? Utils.getUbuntuTextStyleWithSize(20)
            : Utils.getTajwalTextStyleWithSize(20),
      ),
      content: Text(
        MyLocalization.of(context).getTranslatedValue(keyContent),
        style: textDirection == TextDirection.ltr
            ? Utils.getUbuntuTextStyleWithSize(14)
            : Utils.getTajwalTextStyleWithSize(14),
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
                ? Utils.getUbuntuTextStyleWithSize(12)
                : Utils.getTajwalTextStyleWithSize(12),
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
                ? Utils.getUbuntuTextStyleWithSize(12)
                : Utils.getTajwalTextStyleWithSize(12),
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
}