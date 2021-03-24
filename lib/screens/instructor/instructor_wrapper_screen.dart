import 'package:flutter/material.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:provider/provider.dart';
import 'instructor_drawer_screen.dart';
import 'instructor_home_screen.dart';

class InstructorWrapperScreen extends StatefulWidget {
  @override
  _InstructorWrapperScreenState createState() =>
      _InstructorWrapperScreenState();
}

class _InstructorWrapperScreenState extends State<InstructorWrapperScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final Duration duration = Duration(milliseconds: 300);

  @override
  void initState() {
    _controller = AnimationController(duration: duration, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.isDarkMode ? false : true;

    return Scaffold(
      backgroundColor: isLightTheme ? AppTheme.lightTheme.scaffoldBackgroundColor : AppTheme.darkTheme.scaffoldBackgroundColor,

      body: Stack(
        children: [
          InstructorDrawerScreen(
            controller: _controller,
          ),
          InstructorHomeScreen(
            controller: _controller,
            duration: duration,
          )
        ],
      ),
    );
  }
}
