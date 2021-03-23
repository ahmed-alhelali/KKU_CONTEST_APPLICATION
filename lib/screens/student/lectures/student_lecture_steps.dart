import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utils/utils.dart';

class StudentLectureSteps extends StatefulWidget {
  final String title;
  final String id;

  StudentLectureSteps(this.id, this.title);

  @override
  _StudentLectureStepsState createState() => _StudentLectureStepsState();
}

class _StudentLectureStepsState extends State<StudentLectureSteps> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: AppTheme.darkTheme.backgroundColor,
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    widget.title,
                    style: textDirection == TextDirection.ltr
                        ? Utils.getUbuntuTextStyleWithSize(18)
                        : Utils.getTajwalTextStyleWithSize(18),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: getInstructorCourses(textDirection),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getInstructorCourses(TextDirection textDirection) {
    CollectionReference courses = FirebaseFirestore.instance
        .collection("Courses")
        .doc(widget.id)
        .collection("lectures")
        .doc(widget.title)
        .collection("steps");

    return StreamBuilder<QuerySnapshot>(
      stream: courses.orderBy("time").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                MyLocalization.of(context)
                    .getTranslatedValue("error_connection"),
                style: textDirection == TextDirection.ltr
                    ? Utils.getUbuntuTextStyleWithSize(14)
                    : Utils.getTajwalTextStyleWithSize(14),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(),
          );
        }

        if (snapshot.data.size == 0) {
          return Center(
            child: Text(
              MyLocalization.of(context).getTranslatedValue("no_lectures"),
              style: textDirection == TextDirection.ltr
                  ? Utils.getUbuntuTextStyleWithSize(14)
                  : Utils.getTajwalTextStyleWithSize(14),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Stepper(
          type: StepperType.vertical,
          physics: ScrollPhysics(),
          currentStep: _currentStep,
          onStepTapped: (step) => tapped(step),
          onStepContinue: continued,
          onStepCancel: cancel,
          controlsBuilder: (BuildContext context,
              {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      elevation: 0,
                      backgroundColor: HexColor("#5C704D"),
                    ),
                    child: Text(
                      MyLocalization.of(context).getTranslatedValue("next"),
                      style: textDirection == TextDirection.ltr
                          ? Utils.getUbuntuTextStyleWithSize(12)
                          : Utils.getTajwalTextStyleWithSize(12),
                    ),
                    onPressed: () {
                      if (_currentStep < 4) {
                        onStepContinue();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          },
          steps: snapshot.data.docs.map((DocumentSnapshot document) {
            return Step(
              title: Text(
                document.get("title").toString(),
                style: textDirection == TextDirection.ltr
                    ? Utils.getUbuntuTextStyleWithSize(16)
                    : Utils.getTajwalTextStyleWithSize(14),
              ),
              content: Text(
                document.get("description").toString(),
                style: textDirection == TextDirection.ltr
                    ? Utils.getUbuntuTextStyleWithSize(13)
                    : Utils.getTajwalTextStyleWithSize(13),
              ),
              isActive: true,
              state: StepState.indexed,
            );
          }).toList(),
        );
      },
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 4 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}