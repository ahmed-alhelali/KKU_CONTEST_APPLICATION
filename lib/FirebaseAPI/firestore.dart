import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/screens/student/lectures/student_lecture_steps.dart';
import 'package:kku_contest_app/screens/student/lectures/student_lectures_screen.dart';
import 'package:kku_contest_app/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

class FirestoreDB {
  static addCourseWidget(TextDirection textDirection, BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();

    showModalBottomSheet(
      context: context,
      elevation: 10,
      barrierColor: Colors.white10,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      builder: (context) {
        return Container(
          height: 230,
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    MyLocalization.of(context)
                        .getTranslatedValue("create_course"),
                    style: textDirection == TextDirection.ltr
                        ? Utils.getUbuntuTextStyleWithSize(18)
                        : Utils.getTajwalTextStyleWithSize(18),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                      key: formKey,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        child: TextFormField(
                          controller: titleController,
                          cursorColor: Colors.white,
                          style: textDirection == TextDirection.ltr
                              ? Utils.getUbuntuTextStyleWithSize(14)
                              : Utils.getTajwalTextStyleWithSize(14),
                          decoration: InputDecoration(
                            contentPadding: textDirection == TextDirection.ltr
                                ? EdgeInsets.only(left: 30)
                                : EdgeInsets.only(right: 30),
                            labelText: MyLocalization.of(context)
                                .getTranslatedValue("course_name"),
                            labelStyle: textDirection == TextDirection.ltr
                                ? Utils.getUbuntuTextStyleWithSize(12)
                                : Utils.getTajwalTextStyleWithSize(12),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.grey,
                              ),
                              onPressed: () => titleController.clear(),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return MyLocalization.of(context)
                                  .getTranslatedValue("validate_title");
                            }
                            return null;
                          },
                        ),
                      )),
                ],
              ),
              Positioned(
                bottom: 15,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 100,
                          child: FloatingActionButton.extended(
                            elevation: 0,
                            highlightElevation: 0,
                            label: Text(
                              MyLocalization.of(context)
                                  .getTranslatedValue("cancel"),
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: FloatingActionButton.extended(
                            elevation: 0,
                            highlightElevation: 0,
                            label: Text(
                              MyLocalization.of(context)
                                  .getTranslatedValue("create"),
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green.shade800,
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                addCourse(titleController.text);
                                titleController.text = "";
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static addCourse(String courseTitle) {
    CollectionReference newCourse =
        FirebaseFirestore.instance.collection("Courses");
    return newCourse
        .doc(getRandomIdForNewCourse())
        .set({"course_title": courseTitle, "time": DateTime.now()})
        .then((value) => {print("course added")})
        .catchError((error) => print(error));
  }

  static String getRandomIdForNewCourse() {
    var uuid = Uuid();
    return uuid.v4();
  }

  static deleteCourse(courseID) {
    CollectionReference courses =
        FirebaseFirestore.instance.collection("Courses");

    return courses
        .doc(courseID)
        .delete()
        .then((value) => {
              print("Course deleted"),
              deleteAllLecturesUnderCourseDeleted(courseID)
            })
        .catchError((error) => print(error));
  }

  static deleteAllLecturesUnderCourseDeleted(courseID) async {
    CollectionReference courses =
        FirebaseFirestore.instance.collection("Courses");

    final lectures = courses.doc(courseID).collection("lectures").get();
    return await lectures
        .then((lecture) => lecture.docs.forEach((element) {
              element.reference.delete();
            }))
        .then((value) => {})
        .catchError((error) => print(error));
  }

  static deleteLecture(String courseID, String title) {
    CollectionReference courses = FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
        .collection("lectures");

    return courses.doc(title).delete().then((value) => {}).catchError(
          (error) => print(error),
        );
  }

  static deleteAllSteps(String courseID, String title) async {
    CollectionReference courses = FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
        .collection("lectures");

    final lectureSteps = courses.doc(title).collection("steps").get();

    return await lectureSteps
        .then((steps) => steps.docs.forEach((element) {
              element.reference.get();
            }))
        .then((value) => {})
        .catchError((error) => print(error));
  }

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

}
