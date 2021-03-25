import 'package:flutter/material.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/screens/student/student_drawer_screen.dart';
import 'package:kku_contest_app/screens/student/student_home_screen.dart';
import 'package:provider/provider.dart';

class StudentWrapperScreen extends StatefulWidget {
  @override
  _StudentWrapperScreenState createState() =>
      _StudentWrapperScreenState();
}

class _StudentWrapperScreenState extends State<StudentWrapperScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final Duration duration = Duration(milliseconds: 300);

  @override
  void initState() {
    _controller = AnimationController(duration: duration, vsync: this);
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.isDarkMode ? false : true;

    return Scaffold(
      backgroundColor: isLightTheme ? AppTheme.lightTheme.backgroundColor : AppTheme.darkTheme.backgroundColor,
      body: Stack(
        children: [
          StudentDrawerScreen(
            controller: _controller,
          ),
          StudentHomeScreen(
            controller: _controller,
            duration: duration,
          )
        ],
      ),
    );
  }
}