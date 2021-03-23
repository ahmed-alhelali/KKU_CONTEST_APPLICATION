import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/screens/wrapper_screen.dart';
import 'package:kku_contest_app/utils/utils.dart';

class StudentDrawerScreen extends StatefulWidget {
  final AnimationController controller;

  const StudentDrawerScreen({Key key, this.controller}) : super(key: key);

  @override
  _StudentDrawerScreenState createState() => _StudentDrawerScreenState();
}

class _StudentDrawerScreenState extends State<StudentDrawerScreen> {
  Animation<double> _scaleAnimation;
  Animation<Offset> _slideAnimation;

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    if (_scaleAnimation == null) {
      _scaleAnimation =
          Tween<double>(begin: 0.6, end: 1).animate(widget.controller);
    }
    if (_slideAnimation == null) {
      _slideAnimation = textDirection == TextDirection.ltr
          ? Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
          .animate(widget.controller)
          : Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
          .animate(widget.controller);
    }
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        alignment: Alignment.topRight,
        child: Container(
          color: AppTheme.darkTheme.backgroundColor,
          child: ListView(
            children: [
              SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.darkTheme.scaffoldBackgroundColor,
                    borderRadius: textDirection == TextDirection.ltr
                        ? BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    )
                        : BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Center(
                    child: Text(
                      MyLocalization.of(context)
                          .getTranslatedValue("student")
                          .toUpperCase(),
                      style: textDirection == TextDirection.ltr
                          ? Utils.getUbuntuTextStyleWithSize(18)
                          : Utils.getTajwalTextStyleWithSize(18),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage:
                        ExactAssetImage("assets/images/student.png"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        MyLocalization.of(context).getTranslatedValue("student_name"),

                        style: textDirection == TextDirection.ltr
                            ? Utils.getUbuntuTextStyleWithSize(16)
                            : Utils.getTajwalTextStyleWithSize(14),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40),
              Utils.getContainerWithOnOnTap(
                Icon(
                  Icons.menu_book,
                  color: Colors.white,
                ),
                "my_courses",
                textDirection,
                context,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.5,
                //color: Colors.grey,
                margin: EdgeInsets.symmetric(vertical: 10),
              ),
              Utils.getContainerWithOnOnTap(
                Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                "logout",
                textDirection,
                context,
                onTap: () {
                  Utils.showWarringDialog("are_you_sure", "student_logout_warning",
                      context, "logout", "cancel", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WrapperScreen(),
                          ),
                        );
                      }, () {
                        Navigator.of(context).pop();
                      }, textDirection);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}