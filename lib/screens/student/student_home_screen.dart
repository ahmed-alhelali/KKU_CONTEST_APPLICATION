import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utils/utils.dart';
import 'lectures/student_lectures_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  final AnimationController controller;
  final Duration duration;

  const StudentHomeScreen({Key key, this.controller, this.duration})
      : super(key: key);

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  bool menuOpen = false;
  Animation<double> _scaleAnimation;

  final coursesName = [];

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final searchController = TextEditingController();
    if (_scaleAnimation == null) {
      _scaleAnimation =
          Tween<double>(begin: 1, end: 0.6).animate(widget.controller);
    }
    var size = MediaQuery.of(context).size;

    return AnimatedPositioned(
      curve: Curves.fastOutSlowIn,
      duration: widget.duration,
      top: 0,
      bottom: 0,
      left: menuOpen
          ? (textDirection == TextDirection.ltr
          ? 0.3 * size.width
          : -0.3 * size.width)
          : 0,
      right: menuOpen
          ? (textDirection == TextDirection.ltr
          ? -0.3 * size.width
          : 0.3 * size.width)
          : 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Scaffold(
          backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            leading: !menuOpen
                ? IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  widget.controller.forward();
                  menuOpen = true;
                });
              },
              color: Colors.white,
            )
                : IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  widget.controller.reverse();
                  menuOpen = false;
                });
              },
              color: Colors.white,
            ),
            title: Text(
              MyLocalization.of(context).getTranslatedValue("home_page_title"),
              style: textDirection == TextDirection.ltr
                  ? Utils.getUbuntuTextStyleWithSize(14)
                  : Utils.getTajwalTextStyleWithSize(14),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (searchController.text != '') {
                    // getOnce(searchController.text);
                    // String name= getOnce(searchController.text);
                    // setState(() {
                    //   print(getOnce(searchController.text).toString());
                    //   coursesName.add(name);
                    //   searchController.text = '';
                    // });
                  } else {}
                },
                color: Colors.white,
              ),
            ],
            centerTitle: true,
            elevation: 0,
            brightness: AppTheme.darkTheme.appBarTheme.brightness,
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: searchController,
                  style: textDirection == TextDirection.ltr
                      ? Utils.getUbuntuTextStyleWithSize(14)
                      : Utils.getTajwalTextStyleWithSize(14),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.grey)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    hintText:
                    MyLocalization.of(context).getTranslatedValue("search"),
                    hintStyle: textDirection == TextDirection.ltr
                        ? Utils.getUbuntuTextStyleWithSize(12)
                        : Utils.getTajwalTextStyleWithSize(12),
                  ),
                ),
              ),
              Expanded(
                child: getStudentCourses(textDirection),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addCourseToStudent(String courseTitle, id) {
    CollectionReference newCourse =
    FirebaseFirestore.instance.collection("Courses");
    return newCourse
        .doc(id)
        .set({"course_title": courseTitle})
        .then((value) => {print("course added")})
        .catchError((error) => print(error));
  }

  Widget getStudentCourses(TextDirection textDirection) {
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
            // print(currentCourse);
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
//
// Widget getCourses(textDirection) {
//   return ListView(
//     children: coursesName.map((value) {
//       return InkWell(
//         child: Container(
//           alignment: AlignmentDirectional.centerStart,
//           padding: EdgeInsets.symmetric(horizontal: 30),
//           margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//           width: double.infinity,
//           height: MediaQuery.of(context).size.height * 0.09,
//           decoration: BoxDecoration(
//             color: AppTheme.darkTheme.backgroundColor,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Text(
//             value.toString(),
//             style: textDirection == TextDirection.ltr
//                 ? Utils.getUbuntuTextStyleWithSize(16)
//                 : Utils.getTajwalTextStyleWithSize(16),
//           ),
//         ),
//         onTap: () {},
//       );
//     }).toList(),
//   );
// }
//
// Widget get(textDirection, id) {
//   return StreamBuilder(
//     stream:
//         FirebaseFirestore.instance.collection("Courses").doc(id).snapshots(),
//     builder: (context, snapshot) {
//       if (snapshot.hasError) {
//         return Text(
//           MyLocalization.of(context).getTranslatedValue("error_connection"),
//         );
//       }
//
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       }
//
//       if (snapshot.data.size == 0) {
//         return Center(
//           child: Text(
//             MyLocalization.of(context).getTranslatedValue("no_courses"),
//             style: textDirection == TextDirection.ltr
//                 ? Utils.getUbuntuTextStyleWithSize(14)
//                 : Utils.getTajwalTextStyleWithSize(14),
//           ),
//         );
//       }
//       var course = snapshot.data;
//       print(course[id]);
//       return Text(course[id]);
//     },
//   );
// }
//
// Widget getStudentsCourse(textDirection, id) {
//   CollectionReference courses =
//       FirebaseFirestore.instance.collection("Courses");
//   return StreamBuilder<QuerySnapshot>(
//     stream: courses.snapshots(),
//     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//       if (snapshot.hasError) {
//         return Text(
//           MyLocalization.of(context).getTranslatedValue("error_connection"),
//         );
//       }
//
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       }
//
//       if (snapshot.data.size == 0) {
//         return Center(
//           child: Text(
//             MyLocalization.of(context).getTranslatedValue("no_courses"),
//             style: textDirection == TextDirection.ltr
//                 ? Utils.getUbuntuTextStyleWithSize(14)
//                 : Utils.getTajwalTextStyleWithSize(14),
//           ),
//         );
//       }
//       return ListView(
//         padding: EdgeInsets.symmetric(vertical: 6),
//         children: snapshot.data.docs.map(
//           (DocumentSnapshot document) {
//             final currentCourse = document.data().containsKey(id);
//             // print(currentCourse);
//             return InkWell(
//               child: Container(
//                 alignment: AlignmentDirectional.centerStart,
//                 padding: EdgeInsets.symmetric(horizontal: 30),
//                 margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//                 width: double.infinity,
//                 height: MediaQuery.of(context).size.height * 0.09,
//                 decoration: BoxDecoration(
//                   color: AppTheme.darkTheme.backgroundColor,
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Text(
//                   currentCourse.toString(),
//                   style: textDirection == TextDirection.ltr
//                       ? Utils.getUbuntuTextStyleWithSize(16)
//                       : Utils.getTajwalTextStyleWithSize(16),
//                 ),
//               ),
//               onTap: () {
//               },
//             );
//           },
//         ).toList(),
//       );
//     },
//   );
// }
}