import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/screens/instructor/lectures_and_student/help_student_screen.dart';
import 'package:kku_contest_app/screens/instructor/lectures_and_student/lectures/instructor_lectures_screen.dart';
import 'package:kku_contest_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.isDarkMode ? false : true;


    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isLightTheme
            ? AppTheme.lightTheme.scaffoldBackgroundColor
            : AppTheme.darkTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          brightness: isLightTheme ? AppTheme.lightTheme.appBarTheme.brightness : AppTheme.darkTheme.appBarTheme.brightness,
          backgroundColor: Colors.transparent,
          iconTheme: isLightTheme ? AppTheme.lightTheme.appBarTheme.iconTheme : AppTheme.darkTheme.appBarTheme.iconTheme,
          title: Text(
            widget.courseTitle,
            style: textDirection == TextDirection.ltr
                ? Utilities.getUbuntuTextStyleWithSize(16, color: themeProvider.themeColor(isLightTheme).textColor)
                : Utilities.getTajwalTextStyleWithSize(16, color: themeProvider.themeColor(isLightTheme).textColor),
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: isLightTheme ? AppTheme.lightTheme.backgroundColor : HexColor("#322840"),
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
                          ? Utilities.getUbuntuTextStyleWithSize(12, color: themeProvider.themeColor(isLightTheme).textColor)
                          : Utilities.getTajwalTextStyleWithSize(12, color: themeProvider.themeColor(isLightTheme).textColor),
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
                          ? Utilities.getUbuntuTextStyleWithSize(12, color: themeProvider.themeColor(isLightTheme).textColor)
                          : Utilities.getTajwalTextStyleWithSize(12, color: themeProvider.themeColor(isLightTheme).textColor),
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
            HelpStudentScreen(
              id: widget.id,
            ),
          ],
        ),
      ),
    );
  }
}
