import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utils/utils.dart';
import 'lectures and student/help_student_screen.dart';
import 'lectures and student/lectures/instructor_lectures_screen.dart';

class InstructorCourse extends StatefulWidget {
  final String courseTitle;
  final String id;

  InstructorCourse({this.courseTitle, this.id});

  @override
  _InstructorCourseState createState() => _InstructorCourseState();
}

class _InstructorCourseState extends State<InstructorCourse>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          brightness: AppTheme.darkTheme.appBarTheme.brightness,
          backgroundColor: Colors.transparent,
          title: Text(
            widget.courseTitle,
            style: textDirection == TextDirection.ltr
                ? Utils.getUbuntuTextStyleWithSize(16)
                : Utils.getTajwalTextStyleWithSize(16),
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: HexColor("#322840"),
            ),
            tabs: [
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: Colors.redAccent, width: 1)
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      MyLocalization.of(context)
                          .getTranslatedValue("lecture_section"),
                      style: textDirection == TextDirection.ltr
                          ? Utils.getUbuntuTextStyleWithSize(12)
                          : Utils.getTajwalTextStyleWithSize(12),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: Colors.redAccent, width: 1),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      MyLocalization.of(context)
                          .getTranslatedValue("student_section"),
                      style: textDirection == TextDirection.ltr
                          ? Utils.getUbuntuTextStyleWithSize(12)
                          : Utils.getTajwalTextStyleWithSize(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            InstructorLecturesScreen(
              id: widget.id,
            ),
            HelpStudentScreen(),
          ],
        ),
      ),
    );
  }
}
