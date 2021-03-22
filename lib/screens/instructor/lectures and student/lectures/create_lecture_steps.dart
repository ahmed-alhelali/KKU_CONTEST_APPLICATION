import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utils/utils.dart';


class CreateLectureSteps extends StatefulWidget {
  final String id;

  CreateLectureSteps(this.id);

  @override
  _CreateLectureStepsState createState() => _CreateLectureStepsState();
}

class _CreateLectureStepsState extends State<CreateLectureSteps> {
  int _currentStep = 0;

  final lectureTitleController = TextEditingController();
  final messageController = TextEditingController();
  final titleStepController1 = TextEditingController();
  final descriptionStepController1 = TextEditingController();
  final titleStepController2 = TextEditingController();
  final descriptionStepController2 = TextEditingController();
  final titleStepController3 = TextEditingController();
  final descriptionStepController3 = TextEditingController();
  final titleStepController4 = TextEditingController();
  final descriptionStepController4 = TextEditingController();
  final titleStepController5 = TextEditingController();
  final descriptionStepController5 = TextEditingController();
  bool titleValidate = false;
  bool messageValidate = false;
  bool titleValidate1 = false;
  bool titleValidate2 = false;
  bool titleValidate3 = false;
  bool titleValidate4 = false;
  bool titleValidate5 = false;
  bool descValidate1 = false;
  bool descValidate2 = false;
  bool descValidate3 = false;
  bool descValidate4 = false;
  bool descValidate5 = false;

  StepperType stepperType = StepperType.vertical;

  @override
  void dispose() {
    lectureTitleController.dispose();
    messageController.dispose();
    titleStepController1.dispose();
    descriptionStepController1.dispose();
    titleStepController2.dispose();
    descriptionStepController2.dispose();
    titleStepController3.dispose();
    descriptionStepController3.dispose();
    titleStepController4.dispose();
    descriptionStepController4.dispose();
    titleStepController5.dispose();
    descriptionStepController5.dispose();
    super.dispose();
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
              Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: Stepper(
                      type: stepperType,
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
                      steps: _mySteps(
                          textDirection, switchStepsType, continued, cancel),
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

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  List<Step> _mySteps(
      TextDirection textDirection, switchStepsType, continued, cancel) {
    List<Step> _steps = [
      //first
      Step(
        title: Text(
          MyLocalization.of(context).getTranslatedValue("title"),
          style: textDirection == TextDirection.ltr
              ? (_currentStep == 0
              ? Utils.getUbuntuTextStyleWithSize(16)
              : Utils.getUbuntuTextStyleWithSize(16, color: Colors.grey))
              : (_currentStep == 0
              ? Utils.getTajwalTextStyleWithSize(14)
              : Utils.getUbuntuTextStyleWithSize(14, color: Colors.grey)),
        ),
        content: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                TextFormField(
                  controller: lectureTitleController,
                  style: textDirection == TextDirection.ltr
                      ? Utils.getUbuntuTextStyleWithSize(12)
                      : Utils.getTajwalTextStyleWithSize(12),
                  decoration: InputDecoration(
                    errorText: titleValidate
                        ? MyLocalization.of(context)
                        .getTranslatedValue("validate")
                        : null,
                    hintText:
                    MyLocalization.of(context).getTranslatedValue("title"),
                    hintStyle: textDirection == TextDirection.ltr
                        ? Utils.getUbuntuTextStyleWithSize(12,
                        color: Colors.grey)
                        : Utils.getTajwalTextStyleWithSize(12,
                        color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
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
                      // onPressed: continued,
                      onPressed: () {
                        if (lectureTitleController.text.isEmpty) {
                          setState(() {
                            titleValidate = true;
                          });
                        } else {
                          continued();
                        }
                      },
                    ),
                  ],
                ),
              ],
            )),
        isActive: _currentStep == 0,
        state: _currentStep == 0
            ? StepState.editing
            : (_currentStep > 0 ? StepState.complete : StepState.disabled),
      ),

      //second
      Step(
        title: Text(
          MyLocalization.of(context).getTranslatedValue("set_steps"),
          style: textDirection == TextDirection.ltr
              ? (_currentStep == 1
              ? Utils.getUbuntuTextStyleWithSize(16)
              : Utils.getUbuntuTextStyleWithSize(16, color: Colors.grey))
              : (_currentStep == 1
              ? Utils.getTajwalTextStyleWithSize(14)
              : Utils.getUbuntuTextStyleWithSize(14, color: Colors.grey)),
        ),
        content: Column(
          children: [
            Text(
              MyLocalization.of(context)
                  .getTranslatedValue("set_steps_message"),
              style: textDirection == TextDirection.ltr
                  ? Utils.getUbuntuTextStyleWithSize(12)
                  : Utils.getTajwalTextStyleWithSize(12),
            ),
            SizedBox(
              height: 15,
            ),
            getColumnOfTextFields(textDirection, titleStepController1,
                descriptionStepController1),
            SizedBox(
              height: 20,
            ),
            getColumnOfTextFields(textDirection, titleStepController2,
                descriptionStepController2),
            SizedBox(
              height: 20,
            ),
            getColumnOfTextFields(textDirection, titleStepController3,
                descriptionStepController3),
            SizedBox(
              height: 20,
            ),
            getColumnOfTextFields(textDirection, titleStepController4,
                descriptionStepController4),
            SizedBox(
              height: 20,
            ),
            getColumnOfTextFields(textDirection, titleStepController5,
                descriptionStepController5),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    elevation: 0,
                    backgroundColor: HexColor("#A74552"),
                  ),
                  child: Text(
                    MyLocalization.of(context).getTranslatedValue("back"),
                    style: textDirection == TextDirection.ltr
                        ? Utils.getUbuntuTextStyleWithSize(12)
                        : Utils.getTajwalTextStyleWithSize(12),
                  ),
                  // onPressed: continued,
                  onPressed: () {
                    if (_currentStep < 3) {
                      cancel();
                    } else {
                      addNewLecture();
                      // print(descriptionStepController.text);
                      Navigator.pop(context);
                    }
                  },
                ),
                SizedBox(
                  width: 20,
                ),
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
                  // onPressed: continued,
                  onPressed: () {
                    if (_currentStep < 3) {
                      continued();
                    }
                    // } else {
                    //   addNewLecture();
                    //   // print(descriptionStepController.text);
                    //   Navigator.pop(context);
                    // }
                  },
                ),
              ],
            ),
          ],
        ),
        isActive: _currentStep == 1,
        state: _currentStep == 1
            ? StepState.editing
            : (_currentStep > 1 ? StepState.complete : StepState.disabled),
      ),

      //last
      Step(
        title: Text(
          MyLocalization.of(context).getTranslatedValue("help"),
          style: textDirection == TextDirection.ltr
              ? (_currentStep == 2
              ? Utils.getUbuntuTextStyleWithSize(16)
              : Utils.getUbuntuTextStyleWithSize(16, color: Colors.grey))
              : (_currentStep == 2
              ? Utils.getTajwalTextStyleWithSize(14)
              : Utils.getUbuntuTextStyleWithSize(14, color: Colors.grey)),
        ),
        content: Column(
          children: [
            Text(
              MyLocalization.of(context).getTranslatedValue("help_instruction"),
              style: textDirection == TextDirection.ltr
                  ? Utils.getUbuntuTextStyleWithSize(12)
                  : Utils.getTajwalTextStyleWithSize(12),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: messageController,
              style: textDirection == TextDirection.ltr
                  ? Utils.getUbuntuTextStyleWithSize(12)
                  : Utils.getTajwalTextStyleWithSize(12),
              // controller: numberOfStepsController,
              decoration: InputDecoration(
                errorText: messageValidate
                    ? MyLocalization.of(context).getTranslatedValue("validate")
                    : null,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintStyle: textDirection == TextDirection.ltr
                    ? Utils.getUbuntuTextStyleWithSize(12, color: Colors.grey)
                    : Utils.getTajwalTextStyleWithSize(12, color: Colors.grey),
                hintText: MyLocalization.of(context)
                    .getTranslatedValue("write_message"),
              ),
              // validator: messageValidate,
              maxLines: 20,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    elevation: 0,
                    backgroundColor: HexColor("#A74552"),
                  ),
                  child: Text(
                    MyLocalization.of(context).getTranslatedValue("back"),
                    style: textDirection == TextDirection.ltr
                        ? Utils.getUbuntuTextStyleWithSize(12)
                        : Utils.getTajwalTextStyleWithSize(12),
                  ),
                  // onPressed: continued,
                  onPressed: () {
                    cancel();
                  },
                ),
                SizedBox(
                  width: 20,
                ),
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
                  // onPressed: continued,
                  onPressed: () {
                    if (_currentStep < 2) {
                      continued();
                    } else {
                      if (messageController.text.isEmpty) {
                        setState(() {
                          messageValidate = true;
                        });
                      } else {
                        addNewLecture();
                        // print(descriptionStepController.text);
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        isActive: _currentStep == 2,
        state: _currentStep == 2
            ? StepState.editing
            : (_currentStep > 1 ? StepState.complete : StepState.disabled),
      ),
    ];
    return _steps;
  }

  Widget getColumnOfTextFields(
      TextDirection textDirection,
      titleController,
      descriptionController,
      ) {
    return Column(
      children: [
        TextField(
          controller: titleController,
          style: textDirection == TextDirection.ltr
              ? Utils.getUbuntuTextStyleWithSize(12)
              : Utils.getTajwalTextStyleWithSize(12),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintStyle: textDirection == TextDirection.ltr
                ? Utils.getUbuntuTextStyleWithSize(12, color: Colors.grey)
                : Utils.getTajwalTextStyleWithSize(12, color: Colors.grey),
            hintText: MyLocalization.of(context).getTranslatedValue("title"),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: descriptionController,
          style: textDirection == TextDirection.ltr
              ? Utils.getUbuntuTextStyleWithSize(12)
              : Utils.getTajwalTextStyleWithSize(12),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintStyle: textDirection == TextDirection.ltr
                ? Utils.getUbuntuTextStyleWithSize(12, color: Colors.grey)
                : Utils.getTajwalTextStyleWithSize(12, color: Colors.grey),
            hintText:
            MyLocalization.of(context).getTranslatedValue("description"),
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  addNewLecture() {
    CollectionReference newLecture =
    FirebaseFirestore.instance.collection("Courses");

    return newLecture
        .doc(widget.id)
        .collection("lectures")
        .doc(lectureTitleController.text)
        .set({
      "title": lectureTitleController.text,
      "message": messageController.text.isEmpty
          ? "No Message"
          : messageController.text,
    })
        .then((value) => {
      addStepsToFirebase(
        titleStepController1.text,
        descriptionStepController1.text,
        titleStepController2.text,
        descriptionStepController2.text,
        titleStepController3.text,
        descriptionStepController3.text,
        titleStepController4.text,
        descriptionStepController4.text,
        titleStepController5.text,
        descriptionStepController5.text,
      )
    })
        .catchError((error) => print(error));
  }

  addStepsToFirebase(
      String title1,
      String description1,
      String title2,
      String description2,
      String title3,
      String description3,
      String title4,
      String description4,
      String title5,
      String description5,
      ) {
    CollectionReference newLecture =
    FirebaseFirestore.instance.collection("Courses");


    if( title1== "" || title2== "" || title3 == "" || title4 == "" || title5== ""){
      print("TITLES EMPTU");
    }
    List<String> titles = [
      title1,
      title2,
      title3,
      title4,
      title5,
    ];
    List<String> descriptions = [
      description1,
      description2,
      description3,
      description4,
      description5,
    ];

    for (int i = 0; i < 5; i++) {
      newLecture
          .doc(widget.id)
          .collection("lectures")
          .doc(lectureTitleController.text)
          .collection("steps")
          .doc(titles[i])
          .set({"time": DateTime.now() ,"title": titles[i], "description": descriptions[i]});
    }
  }
}