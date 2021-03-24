import 'package:flutter/material.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/widgets/instructor_widgets/instructor_widgets.dart';
import 'package:provider/provider.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.isDarkMode ? false : true;


    return Scaffold(
      backgroundColor: isLightTheme
          ? AppTheme.lightTheme.scaffoldBackgroundColor
          : AppTheme.darkTheme.scaffoldBackgroundColor,
      body: InstructorWidgets.getInstructorLectures( themeProvider, isLightTheme, textDirection,widget.id),
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
}