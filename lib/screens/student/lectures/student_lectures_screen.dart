import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/screens/chatScreen.dart';
import 'package:kku_contest_app/utilities/utilities.dart';
import 'package:kku_contest_app/widgets/shared_widgets.dart';
import 'package:kku_contest_app/widgets/student_widgets/student_widgets.dart';
import 'package:provider/provider.dart';

class StudentLectureScreen extends StatefulWidget {
  final String title;
  final String id;

  const StudentLectureScreen({Key key, this.id, this.title}) : super(key: key);

  @override
  _StudentLectureScreenState createState() => _StudentLectureScreenState();
}

class _StudentLectureScreenState extends State<StudentLectureScreen> {
  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.isDarkMode ? false : true;

    return Scaffold(
      backgroundColor: isLightTheme
          ? AppTheme.lightTheme.scaffoldBackgroundColor
          : AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        brightness: isLightTheme
            ? AppTheme.lightTheme.appBarTheme.brightness
            : AppTheme.darkTheme.appBarTheme.brightness,
        backgroundColor: isLightTheme
            ? AppTheme.lightTheme.backgroundColor
            : AppTheme.darkTheme.backgroundColor,
        iconTheme: isLightTheme
            ? AppTheme.lightTheme.appBarTheme.iconTheme
            : AppTheme.darkTheme.appBarTheme.iconTheme,
        title: Text(
          widget.title.toUpperCase(),
          style: textDirection == TextDirection.ltr
              ? Utilities.getUbuntuTextStyleWithSize(16,
                  color: themeProvider.themeColor(isLightTheme).textColor)
              : Utilities.getTajwalTextStyleWithSize(16,
                  color: themeProvider.themeColor(isLightTheme).textColor),
        ),
      ),
      body: StudentWidgets.getStudentLectures(
          themeProvider, isLightTheme, textDirection, widget.id),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(6),
        child: FloatingActionButton(
          highlightElevation: 0,
          elevation: 0,
          backgroundColor: Colors.green.shade800,
          onPressed: () async {
            String name = textDirection == TextDirection.ltr
                ? "Abdullah Mohammad"
                : "عبدالله محمد الغامدي";

            final snapShot = await FirebaseFirestore.instance
                .collection("Courses")
                .doc(widget.id)
                .collection("chats")
                .doc(widget.id)
                .get();

            if (snapShot.exists) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(name, widget.id),
                ),
              );
            } else {
              Widgets.showWarringDialog(
                themeProvider,
                isLightTheme,
                "chat_not_exist_title",
                "chat_not_exist_content",
                context,
                "logout",
                "i_get_it",
                textDirection,
                functionOfNoButton: () {
                  Navigator.pop(context);
                },
              );
            }
          },
          child: Icon(
            FontAwesomeIcons.solidCommentAlt,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
