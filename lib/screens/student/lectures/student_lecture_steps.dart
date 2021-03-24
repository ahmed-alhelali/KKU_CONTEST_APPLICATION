import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utilities/utilities.dart';

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
          padding: EdgeInsets.symmetric(vertical: 10),
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
                        ? Utilities.getUbuntuTextStyleWithSize(18)
                        : Utilities.getTajwalTextStyleWithSize(18),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: getStudentLectureSteps(textDirection),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getStudentLectureSteps(TextDirection textDirection) {
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
                    ? Utilities.getUbuntuTextStyleWithSize(14)
                    : Utilities.getTajwalTextStyleWithSize(14),
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
                  ? Utilities.getUbuntuTextStyleWithSize(14)
                  : Utilities.getTajwalTextStyleWithSize(14),
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
            return Container();
          },
          steps: snapshot.data.docs.map((DocumentSnapshot document) {
            if (document.data().values.contains("Help")) {
              return Step(
                title: Text(
                  document.get("title").toString(),
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(16)
                      : Utilities.getTajwalTextStyleWithSize(14),
                ),
                content: Column(
                  children: [
                    Text(
                      document.get("description").toString(),
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(13)
                          : Utilities.getTajwalTextStyleWithSize(13),
                    ),
                    SizedBox(height: 25,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              elevation: 0,
                              backgroundColor: HexColor("#A74552"),
                            ),
                            child: Text(
                              MyLocalization.of(context).getTranslatedValue("i_have_issues"),
                              style: textDirection == TextDirection.ltr
                                  ? Utilities.getUbuntuTextStyleWithSize(12)
                                  : Utilities.getTajwalTextStyleWithSize(12),
                            ),
                            onPressed: (){},
                          ),
                          SizedBox(width: 50,),
                          TextButton(
                            style: TextButton.styleFrom(
                              elevation: 0,
                              backgroundColor: HexColor("#5C704D"),
                            ),
                            child: Text(
                              MyLocalization.of(context).getTranslatedValue("no_thanks"),
                              style: textDirection == TextDirection.ltr
                                  ? Utilities.getUbuntuTextStyleWithSize(12)
                                  : Utilities.getTajwalTextStyleWithSize(12),
                            ),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                isActive: true,
                state: StepState.indexed,
              );
            } else {
              return Step(
                title: Text(
                  document.get("title").toString(),
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(16)
                      : Utilities.getTajwalTextStyleWithSize(14),
                ),
                content: Column(
                  children: [
                    Text(
                      document.get("description").toString(),
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(13)
                          : Utilities.getTajwalTextStyleWithSize(13),
                    ),
                    SizedBox(height: 25,),
                    Padding(
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
                                  ? Utilities.getUbuntuTextStyleWithSize(12)
                                  : Utilities.getTajwalTextStyleWithSize(12),
                            ),
                            onPressed: () {
                              if (_currentStep < 5) {
                                continued();
                              } else {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                isActive: true,
                state: StepState.indexed,
              );
            }
          }).toList(),
        );
      },
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 5 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
