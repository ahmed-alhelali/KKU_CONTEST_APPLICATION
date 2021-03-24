import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kku_contest_app/FirebaseAPI/firestore.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utilities/utilities.dart';
import 'package:toast/toast.dart';

class InstructorWidgets{



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
                        ? Utilities.getUbuntuTextStyleWithSize(18)
                        : Utilities.getTajwalTextStyleWithSize(18),
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
                              ? Utilities.getUbuntuTextStyleWithSize(14)
                              : Utilities.getTajwalTextStyleWithSize(14),
                          decoration: InputDecoration(
                            contentPadding: textDirection == TextDirection.ltr
                                ? EdgeInsets.only(left: 30)
                                : EdgeInsets.only(right: 30),
                            labelText: MyLocalization.of(context)
                                .getTranslatedValue("course_name"),
                            labelStyle: textDirection == TextDirection.ltr
                                ? Utilities.getUbuntuTextStyleWithSize(12)
                                : Utilities.getTajwalTextStyleWithSize(12),
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
                          maxLength: 37,
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
                            onPressed: () async {
                              CollectionReference newCourse = FirebaseFirestore
                                  .instance
                                  .collection("Courses");

                              if (formKey.currentState.validate()) {
                                var response = await newCourse
                                    .where("course_title",
                                    isEqualTo: titleController.text)
                                    .snapshots()
                                    .first;
                                if (response.docs.length > 0) {
                                  Toast.show(
                                    MyLocalization.of(context)
                                        .getTranslatedValue(
                                        "course_already_exist"),
                                    context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.CENTER,
                                  );
                                } else {
                                  FirestoreDB.addCourse(titleController.text);
                                  titleController.text = "";
                                }
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
                    ? Utilities.getUbuntuTextStyleWithSize(14)
                    : Utilities.getTajwalTextStyleWithSize(14),
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
                  ? Utilities.getUbuntuTextStyleWithSize(14)
                  : Utilities.getTajwalTextStyleWithSize(14),
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
                          ? Utilities.getUbuntuTextStyleWithSize(12)
                          : Utilities.getTajwalTextStyleWithSize(12),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 25,
                      ),
                      onPressed: () {
                        FirestoreDB.deleteAllStepsUnderLecture(
                            courseID, titleLecture);
                        FirestoreDB.deleteLecture(courseID,titleLecture);
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

  static Widget getColumnOfTextFields(
      BuildContext context,
      TextDirection textDirection,
      titleController,
      descriptionController,
      ) {
    return Column(
      children: [
        TextField(
          controller: titleController,
          style: textDirection == TextDirection.ltr
              ? Utilities.getUbuntuTextStyleWithSize(12)
              : Utilities.getTajwalTextStyleWithSize(12),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintStyle: textDirection == TextDirection.ltr
                ? Utilities.getUbuntuTextStyleWithSize(12, color: Colors.grey)
                : Utilities.getTajwalTextStyleWithSize(12, color: Colors.grey),
            hintText: MyLocalization.of(context).getTranslatedValue("title"),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: descriptionController,
          style: textDirection == TextDirection.ltr
              ? Utilities.getUbuntuTextStyleWithSize(12)
              : Utilities.getTajwalTextStyleWithSize(12),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintStyle: textDirection == TextDirection.ltr
                ? Utilities.getUbuntuTextStyleWithSize(12, color: Colors.grey)
                : Utilities.getTajwalTextStyleWithSize(12, color: Colors.grey),
            hintText:
            MyLocalization.of(context).getTranslatedValue("description"),
          ),
          maxLines: 4,
        ),
      ],
    );
  }
}