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

  List<String> titles = [];
  List<String> descriptions = [];

  @override
  void initState() {
    getAllSteps(widget.id, widget.title);
    super.initState();
  }

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
                    child: titles.length == 0
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Stepper(
                            type: StepperType.vertical,
                            physics: ScrollPhysics(),
                            currentStep: _currentStep,
                            onStepTapped: (step) => tapped(step),
                            onStepContinue: continued,
                            onStepCancel: cancel,
                            controlsBuilder: (BuildContext context,
                                {VoidCallback onStepContinue,
                                VoidCallback onStepCancel}) {
                              return Container();
                            },
                            steps: titles.map((e) {
                              return Step(
                                title: Text(
                                  e.toString(),
                                  style: textDirection == TextDirection.ltr
                                      ? Utilities.getUbuntuTextStyleWithSize(16)
                                      : Utilities.getTajwalTextStyleWithSize(
                                          14),
                                ),
                                content: Column(
                                  children: [
                                    Text(
                                      descriptions[_currentStep],
                                      style: textDirection == TextDirection.ltr
                                          ? Utilities
                                              .getUbuntuTextStyleWithSize(13)
                                          : Utilities
                                              .getTajwalTextStyleWithSize(13),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    _currentStep == 5
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        HexColor("#A74552"),
                                                  ),
                                                  child: Text(
                                                    MyLocalization.of(context)
                                                        .getTranslatedValue(
                                                            "i_have_issues"),
                                                    style: textDirection ==
                                                            TextDirection.ltr
                                                        ? Utilities
                                                            .getUbuntuTextStyleWithSize(
                                                                12)
                                                        : Utilities
                                                            .getTajwalTextStyleWithSize(
                                                                12),
                                                  ),
                                                  //TODO: Show dialog to choose which steps the student have issues with
                                                  onPressed: () {},
                                                ),
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        HexColor("#5C704D"),
                                                  ),
                                                  child: Text(
                                                    MyLocalization.of(context)
                                                        .getTranslatedValue(
                                                            "no_thanks"),
                                                    style: textDirection ==
                                                            TextDirection.ltr
                                                        ? Utilities
                                                            .getUbuntuTextStyleWithSize(
                                                                12)
                                                        : Utilities
                                                            .getTajwalTextStyleWithSize(
                                                                12),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        HexColor("#5C704D"),
                                                  ),
                                                  child: Text(
                                                    MyLocalization.of(context)
                                                        .getTranslatedValue(
                                                            "next"),
                                                    style: textDirection ==
                                                            TextDirection.ltr
                                                        ? Utilities
                                                            .getUbuntuTextStyleWithSize(
                                                                12)
                                                        : Utilities
                                                            .getTajwalTextStyleWithSize(
                                                                12),
                                                  ),
                                                  onPressed: () {
                                                    print(descriptions);
                                                    print(titles.length);
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
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getAllSteps(courseID, lectureTitle) async {
    var courses = FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
        .collection("lectures")
        .doc(lectureTitle)
        .collection("steps")
        .orderBy("time");

    return await courses.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        setState(() {
          titles.add(element.data().values.last.toString());
          descriptions.add(element.data().values.first.toString());
        });
      });
    }).catchError((error) {
      print(error.toString());
    });
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