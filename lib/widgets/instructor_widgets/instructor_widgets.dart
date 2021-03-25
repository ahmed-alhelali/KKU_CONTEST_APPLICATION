import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kku_contest_app/FirebaseAPI/firestore.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/screens/instructor/instructor_course_screen.dart';
import 'package:kku_contest_app/utilities/utilities.dart';
import 'package:kku_contest_app/widgets/shared_widgets.dart';
import 'package:toast/toast.dart';

class InstructorWidgets {
  static Widget getInstructorCourses(ThemeProvider themeProvider,
      bool isLightTheme, TextDirection textDirection) {
    CollectionReference courses =
        FirebaseFirestore.instance.collection("Courses");
    final slidableController = new SlidableController();
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
                  ? Utilities.getUbuntuTextStyleWithSize(14)
                  : Utilities.getTajwalTextStyleWithSize(14),
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(vertical: 6),
          children: snapshot.data.docs.map(
            (DocumentSnapshot document) {
              final currentCourse = document.data().values;
              return Slidable(
                child: InkWell(
                  child: Container(
                    alignment: AlignmentDirectional.centerStart,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.09,
                    decoration: BoxDecoration(
                      color: isLightTheme
                          ? AppTheme.lightTheme.backgroundColor
                          : AppTheme.darkTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      currentCourse.first,
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(16,
                              color: themeProvider
                                  .themeColor(isLightTheme)
                                  .textColor)
                          : Utilities.getTajwalTextStyleWithSize(16,
                              color: themeProvider
                                  .themeColor(isLightTheme)
                                  .textColor),
                    ),
                  ),
                  onTap: () {
                    courseID = document.id;
                    print(courseID);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InstructorCourse(
                          id: courseID,
                          courseTitle: currentCourse.first,
                        ),
                      ),
                    );
                  },
                ),
                actionPane: SlidableStrechActionPane(),
                controller: slidableController,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: IconSlideAction(
                        caption: MyLocalization.of(context)
                            .getTranslatedValue("delete"),
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          Widgets.showWarringDialog(
                            themeProvider,
                            isLightTheme,
                            "are_you_sure",
                            "delete_course_warring",
                            context,
                            "delete",
                            "cancel",
                            () {
                              FirestoreDB.deleteCourse(document.id);
                              Navigator.pop(context);
                            },
                            () {
                              Navigator.pop(context);
                            },
                            textDirection,
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: IconSlideAction(
                        caption: MyLocalization.of(context)
                            .getTranslatedValue("get_id"),
                        color:
                            isLightTheme ? Colors.grey.shade100 : Colors.grey,
                        icon: FontAwesomeIcons.link,
                        onTap: () {
                          print(document.id);
                          Clipboard.setData(ClipboardData(text: document.id))
                              .then((value) {
                            final snackBar = SnackBar(
                              elevation: 0,
                              backgroundColor: isLightTheme
                                  ? AppTheme.lightTheme.backgroundColor
                                  : AppTheme.darkTheme.scaffoldBackgroundColor,
                              content: Text(
                                MyLocalization.of(context)
                                    .getTranslatedValue("course_id_copied"),
                                style: TextStyle(
                                  color: themeProvider
                                      .themeColor(isLightTheme)
                                      .textColor,
                                ),
                              ),
                              action: SnackBarAction(
                                textColor: themeProvider
                                    .themeColor(isLightTheme)
                                    .textColor,
                                label: MyLocalization.of(context)
                                    .getTranslatedValue("close"),
                                onPressed: () {},
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        },
                      ),
                    ),
                  ),
                ],
                secondaryActions: [],
              );
            },
          ).toList(),
        );
      },
    );
  }

  static addCourseWidget(
      ThemeProvider themeProvider,
      bool isLightTheme,
      TextDirection textDirection,
      BuildContext context,
      TextEditingController titleController) {
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      elevation: 10,
      barrierColor: isLightTheme ? Colors.black54 : Colors.white10,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: isLightTheme
          ? AppTheme.lightTheme.scaffoldBackgroundColor
          : AppTheme.darkTheme.scaffoldBackgroundColor,
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
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: 150,
                    height: 4,
                    decoration: BoxDecoration(
                      color: themeProvider.themeColor(isLightTheme).textColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  Text(
                    MyLocalization.of(context)
                        .getTranslatedValue("create_course"),
                    style: textDirection == TextDirection.ltr
                        ? Utilities.getUbuntuTextStyleWithSize(18,
                            color: themeProvider
                                .themeColor(isLightTheme)
                                .textColor)
                        : Utilities.getTajwalTextStyleWithSize(18,
                            color: themeProvider
                                .themeColor(isLightTheme)
                                .textColor),
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
                          cursorColor: isLightTheme ? Colors.black : Colors.white,
                          style: textDirection == TextDirection.ltr
                              ? Utilities.getUbuntuTextStyleWithSize(
                                  14,
                                  color: themeProvider
                                      .themeColor(isLightTheme)
                                      .textColor,
                                )
                              : Utilities.getTajwalTextStyleWithSize(
                                  14,
                                  color: themeProvider
                                      .themeColor(isLightTheme)
                                      .textColor,
                                ),
                          decoration: InputDecoration(
                            contentPadding: textDirection == TextDirection.ltr
                                ? EdgeInsets.only(left: 30)
                                : EdgeInsets.only(right: 30),
                            labelText: MyLocalization.of(context)
                                .getTranslatedValue("course_name"),
                            labelStyle: textDirection == TextDirection.ltr
                                ? Utilities.getUbuntuTextStyleWithSize(12,
                                    color: themeProvider
                                        .themeColor(isLightTheme)
                                        .textColor)
                                : Utilities.getTajwalTextStyleWithSize(12,
                                    color: themeProvider
                                        .themeColor(isLightTheme)
                                        .textColor),
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
                            backgroundColor: HexColor("#A74552"),
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
                            backgroundColor: HexColor("#5C704D"),
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

  static Widget getInstructorLectures(ThemeProvider themeProvider,
      bool isLightTheme, TextDirection textDirection, courseID) {
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
                    ? Utilities.getUbuntuTextStyleWithSize(14,
                        color: Colors.red)
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
                  ? Utilities.getUbuntuTextStyleWithSize(14,
                      color: themeProvider.themeColor(isLightTheme).textColor)
                  : Utilities.getTajwalTextStyleWithSize(14,
                      color: themeProvider.themeColor(isLightTheme).textColor),
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
                          ? Utilities.getUbuntuTextStyleWithSize(12,
                              color: themeProvider
                                  .themeColor(isLightTheme)
                                  .textColor)
                          : Utilities.getTajwalTextStyleWithSize(12,
                              color: themeProvider
                                  .themeColor(isLightTheme)
                                  .textColor),
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
                        FirestoreDB.deleteLecture(courseID, titleLecture);
                      },
                    ),
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

  static Widget getColumnOfTextFields(
    ThemeProvider themeProvider,
    bool isLightTheme,
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
              ? Utilities.getUbuntuTextStyleWithSize(12,
                  color: themeProvider.themeColor(isLightTheme).textColor)
              : Utilities.getTajwalTextStyleWithSize(12,
                  color: themeProvider.themeColor(isLightTheme).textColor),
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
              ? Utilities.getUbuntuTextStyleWithSize(12,
                  color: themeProvider.themeColor(isLightTheme).textColor)
              : Utilities.getTajwalTextStyleWithSize(12,
                  color: themeProvider.themeColor(isLightTheme).textColor),
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
