import 'package:kku_contest_app/imports.dart';

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
    final _multipleNotifier = Provider.of<MultipleNotifier>(context,listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          margin: EdgeInsets.only(left: 12, right: 12, bottom: 5),
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).backgroundColor,
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).appBarTheme.iconTheme.color,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Text(
                    widget.title,
                    style: textDirection == TextDirection.ltr
                        ? Utilities.getUbuntuTextStyleWithSize(
                            18,
                            color: Theme.of(context).textTheme.caption.color,
                            fontWeight: FontWeight.bold,
                          )
                        : Utilities.getTajwalTextStyleWithSize(
                            18,
                            color: Theme.of(context).textTheme.caption.color,
                            fontWeight: FontWeight.bold,
                          ),
                    textAlign: TextAlign.center,
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
                                      ? Utilities.getUbuntuTextStyleWithSize(
                                          16,
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        )
                                      : Utilities.getTajwalTextStyleWithSize(
                                          14,
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        ),
                                ),
                                content: Column(
                                  children: [
                                    Text(
                                      descriptions[_currentStep],
                                      style: textDirection == TextDirection.ltr
                                          ? Utilities
                                              .getUbuntuTextStyleWithSize(
                                              13,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .color,
                                            )
                                          : Utilities
                                              .getTajwalTextStyleWithSize(
                                              13,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .color,
                                            ),
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
                                                  onPressed: () async {
                                                    List<String>
                                                        mySelectedTitles =
                                                        _multipleNotifier
                                                            .selectedItems;

                                                    print(
                                                        "mySelectedTitles = $mySelectedTitles");
                                                    String id =
                                                        await FirebaseUtilities
                                                            .getUserId();

                                                    if (mySelectedTitles
                                                        .isEmpty) {
                                                      StudentWidgets
                                                          .showChoiceStepsIssuesDialog(
                                                              widget.id,
                                                              widget.title,
                                                              titles,
                                                              context,
                                                              textDirection,
                                                              id: id);
                                                    } else {
                                                      Widgets
                                                          .getDialogToAskIfNeedMoreSteps(
                                                        mySelectedTitles,
                                                        "you_asked_help",
                                                        context,
                                                        "yes",
                                                        "no",
                                                        textDirection,
                                                        () {
                                                          StudentWidgets
                                                              .showChoiceStepsIssuesDialog(
                                                                  widget.id,
                                                                  widget.title,
                                                                  titles,
                                                                  context,
                                                                  textDirection,
                                                                  id: id);
                                                        },
                                                        () {
                                                          if (id ==
                                                              "50Un4ErjskQVOrubCLzUloBsvHl1") {
                                                            Toast.show(
                                                              MyLocalization.of(
                                                                      context)
                                                                  .getTranslatedValue(
                                                                      "you_cannot_create_chatting"),
                                                              context,
                                                              duration: Toast
                                                                  .LENGTH_LONG,
                                                              gravity:
                                                                  Toast.BOTTOM,
                                                            );
                                                          } else {
                                                            String name = textDirection ==
                                                                    TextDirection
                                                                        .ltr
                                                                ? "Abdullah Mohammad"
                                                                : "عبدالله محمد الغامدي";

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ChatScreen(
                                                                        name,
                                                                        widget
                                                                            .id),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      );
                                                    }
                                                  },
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
          titles.add(element.get("title").toString());
          descriptions.add(element.get("description").toString());
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
