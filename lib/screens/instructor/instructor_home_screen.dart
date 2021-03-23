import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kku_contest_app/FirebaseAPI/firestore.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utils/utils.dart';
import 'package:kku_contest_app/widgets/instructor_widgets/instructor_widgets.dart';
import 'package:kku_contest_app/widgets/widgets.dart';
import 'instructor_course_screen.dart';

class InstructorHomeScreen extends StatefulWidget {
  final AnimationController controller;
  final Duration duration;

  const InstructorHomeScreen({Key key, this.controller, this.duration})
      : super(key: key);

  @override
  _InstructorHomeScreenState createState() => _InstructorHomeScreenState();
}

class _InstructorHomeScreenState extends State<InstructorHomeScreen> {
  bool menuOpen = false;
  Animation<double> _scaleAnimation;

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

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
            centerTitle: true,
            elevation: 0,
            brightness: AppTheme.darkTheme.appBarTheme.brightness,
            backgroundColor: Colors.transparent,
          ),
          body: getInstructorCourses(textDirection),
          floatingActionButton: Padding(
            padding: EdgeInsets.all(6),
            child: FloatingActionButton(
              highlightElevation: 0,
              elevation: 0,
              backgroundColor: Colors.green.shade800,
              onPressed: () {
                InstructorWidgets.addCourseWidget(textDirection, context);
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 45,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getInstructorCourses(TextDirection textDirection) {
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
                  ? Utils.getUbuntuTextStyleWithSize(14)
                  : Utils.getTajwalTextStyleWithSize(14),
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
                        caption: "DELETE",
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          Widgets.showWarringDialog(
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
                        caption: "GET ID",
                        color: Colors.grey,
                        icon: FontAwesomeIcons.link,
                        onTap: () {
                          print(document.id);
                          Clipboard.setData(ClipboardData(text: document.id))
                              .then((value) {
                            final snackBar = SnackBar(
                              elevation: 0,
                              backgroundColor:
                                  AppTheme.darkTheme.scaffoldBackgroundColor,
                              content: Text(MyLocalization.of(context)
                                  .getTranslatedValue("course_id_copied")),
                              action: SnackBarAction(
                                textColor: Colors.white,
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
}
