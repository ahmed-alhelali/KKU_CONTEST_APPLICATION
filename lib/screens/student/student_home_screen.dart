import 'package:flutter/material.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utilities/utilities.dart';
import 'package:kku_contest_app/widgets/student_widgets/student_widgets.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.isDarkMode ? false : true;
    // final searchController = TextEditingController();
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
              : -0.35 * size.width)
          : 0,
      right: menuOpen
          ? (textDirection == TextDirection.ltr
              ? -0.35 * size.width
              : 0.3 * size.width)
          : 0,
      child: ScaleTransition(
          scale: _scaleAnimation,
          child: ClipRRect(
            borderRadius:
                menuOpen ? BorderRadius.circular(30) : BorderRadius.circular(0),
            child: Scaffold(
              backgroundColor: isLightTheme ? AppTheme.lightTheme.scaffoldBackgroundColor : AppTheme.darkTheme.scaffoldBackgroundColor,
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
                  color: isLightTheme ? Colors.black : Colors.white,
                      )
                    : IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          setState(() {
                            widget.controller.reverse();
                            menuOpen = false;
                          });
                        },
                  color: isLightTheme ? Colors.black : Colors.white,
                      ),
                title: Text(
                  MyLocalization.of(context)
                      .getTranslatedValue("home_page_title"),
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(14,color: themeProvider.themeColor(isLightTheme).textColor)
                      : Utilities.getTajwalTextStyleWithSize(14,color: themeProvider.themeColor(isLightTheme).textColor),
                ),
                centerTitle: true,
                elevation: 0,
                brightness: AppTheme.darkTheme.appBarTheme.brightness,
                backgroundColor: Colors.transparent,
              ),
              body: StudentWidgets.getStudentCourses(themeProvider, isLightTheme ,textDirection),
            ),
          )),
    );
  }
}
