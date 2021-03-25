import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kku_contest_app/controllers/multi_chose.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/screens/student/lectures/student_lecture_steps.dart';
import 'package:kku_contest_app/screens/student/lectures/student_lectures_screen.dart';
import 'package:kku_contest_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class StudentWidgets{
  static Widget getStudentCourses(ThemeProvider themeProvider , bool isLightTheme, TextDirection textDirection) {
    CollectionReference courses =
    FirebaseFirestore.instance.collection("Courses");
    String courseID;
    return StreamBuilder<QuerySnapshot>(
      stream: courses.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(
            MyLocalization.of(context).getTranslatedValue("error_connection"),
            style: textDirection == TextDirection.ltr
                ? Utilities.getUbuntuTextStyleWithSize(14,color: themeProvider.themeColor(isLightTheme).textColor)
                : Utilities.getTajwalTextStyleWithSize(14,color: themeProvider.themeColor(isLightTheme).textColor),

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
                  ? Utilities.getUbuntuTextStyleWithSize(14,color: themeProvider.themeColor(isLightTheme).textColor)
                  : Utilities.getTajwalTextStyleWithSize(14,color: themeProvider.themeColor(isLightTheme).textColor),
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
                  color: isLightTheme ?  AppTheme.lightTheme.backgroundColor : AppTheme.darkTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  currentCourse.first,
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(16,color: themeProvider.themeColor(isLightTheme).textColor)
                      : Utilities.getTajwalTextStyleWithSize(16,color: themeProvider.themeColor(isLightTheme).textColor),
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
  static Widget getStudentLectures(ThemeProvider themeProvider, bool isLightTheme , TextDirection textDirection,courseID) {
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
                    ? Utilities.getUbuntuTextStyleWithSize(14,color: themeProvider.themeColor(isLightTheme).textColor)
                    : Utilities.getTajwalTextStyleWithSize(14,color: themeProvider.themeColor(isLightTheme).textColor),
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
                  ? Utilities.getUbuntuTextStyleWithSize(14,color: themeProvider.themeColor(isLightTheme).textColor)
                  : Utilities.getTajwalTextStyleWithSize(14,color: themeProvider.themeColor(isLightTheme).textColor),
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
                          ? Utilities.getUbuntuTextStyleWithSize(12,color: themeProvider.themeColor(isLightTheme).textColor)
                          : Utilities.getTajwalTextStyleWithSize(12,color: themeProvider.themeColor(isLightTheme).textColor),
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
                        color: isLightTheme ? Colors.grey : Colors.white54,
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

  static showChoiceStepsIssuesDialog(List titles,
      BuildContext context, bool isLightTheme, TextDirection textDirection) {
    return showDialog(
      barrierColor: isLightTheme ? Colors.black54 : Colors.white10,

      context: context,
      builder: (context) {
        final _multipleNotifier = Provider.of<MultipleNotifier>(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 10,
          backgroundColor: isLightTheme
              ? AppTheme.lightTheme.backgroundColor
              : AppTheme.darkTheme.backgroundColor,
          title: Text(
            MyLocalization.of(context).getTranslatedValue("which_steps_title"),
            style: textDirection == TextDirection.ltr
                ? Utilities.getUbuntuTextStyleWithSize(16,fontWeight: FontWeight.bold,
                color: isLightTheme ? Colors.black : Colors.white)
                : Utilities.getTajwalTextStyleWithSize(16,fontWeight: FontWeight.bold,
                color: isLightTheme ? Colors.black : Colors.white),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: titles.getRange(0, 5)
                    .map(
                      (e) => CheckboxListTile(
                    activeColor: HexColor("#5C704D"),
                    title: Text(
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
                    onChanged: (value) {
                      value
                          ? _multipleNotifier.addItem(e)
                          : _multipleNotifier.removeItem(e);
                    },
                    value: _multipleNotifier.isHaveItem(e),
                  ),
                )
                    .toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                elevation: 0,
                backgroundColor: HexColor("#A74552"),
              ),
              child: Text(
                MyLocalization.of(context).getTranslatedValue("cancel"),
                style: textDirection == TextDirection.ltr
                    ? Utilities.getUbuntuTextStyleWithSize(13)
                    : Utilities.getTajwalTextStyleWithSize(13),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              width: 10,
            ),
            TextButton(
              style: TextButton.styleFrom(
                elevation: 0,
                backgroundColor: HexColor("#5C704D"),
              ),
              child: Text(
                MyLocalization.of(context).getTranslatedValue("send"),
                style: textDirection == TextDirection.ltr
                    ? Utilities.getUbuntuTextStyleWithSize(12)
                    : Utilities.getTajwalTextStyleWithSize(12),
              ),
              onPressed: () {},
            ),
            SizedBox(
              width: 10,
            ),
          ],
        );
      },
    );
  }
}