import 'package:kku_contest_app/imports.dart';

class StudentWidgets {
  static Widget getStudentCourses(ThemeProvider themeProvider,
      bool isLightTheme, TextDirection textDirection,
      {String id}) {
    CollectionReference courses =
        FirebaseFirestore.instance.collection("Courses");
    String courseID;

    return StreamBuilder<QuerySnapshot>(
      stream: courses.where("access_by_student", isEqualTo: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(
            MyLocalization.of(context).getTranslatedValue("error_connection"),
            style: textDirection == TextDirection.ltr
                ? Utilities.getUbuntuTextStyleWithSize(14,
                    color: themeProvider.themeColor(isLightTheme).textColor)
                : Utilities.getTajwalTextStyleWithSize(14,
                    color: themeProvider.themeColor(isLightTheme).textColor),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data.size == 0) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                MyLocalization.of(context)
                    .getTranslatedValue("no_courses_student"),
                style: textDirection == TextDirection.ltr
                    ? Utilities.getUbuntuTextStyleWithSize(14,
                        color: themeProvider.themeColor(isLightTheme).textColor)
                    : Utilities.getTajwalTextStyleWithSize(14,
                        color:
                            themeProvider.themeColor(isLightTheme).textColor),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(vertical: 6),
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            final currentCourse = document.get("course_title");
            return InkWell(
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                padding: EdgeInsets.symmetric(horizontal: 30),
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.09,
                decoration: BoxDecoration(
                  color: isLightTheme
                      ? AppTheme.lightTheme.backgroundColor
                      : AppTheme.darkTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  currentCourse,
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(16,
                          color:
                              themeProvider.themeColor(isLightTheme).textColor)
                      : Utilities.getTajwalTextStyleWithSize(16,
                          color:
                              themeProvider.themeColor(isLightTheme).textColor),
                ),
              ),
              onTap: () {
                courseID = document.id;
                print(courseID);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentLectureScreen(
                      id: courseID,
                      title: currentCourse,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
  static Widget getStudentCoursesInDrawer(ThemeProvider themeProvider,
      bool isLightTheme, TextDirection textDirection) {
    CollectionReference courses =
    FirebaseFirestore.instance.collection("Courses");

    return StreamBuilder<QuerySnapshot>(
      stream: courses.where("access_by_student",isEqualTo: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  MyLocalization.of(context)
                      .getTranslatedValue("error_connection"),
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(14,
                      color:
                      themeProvider.themeColor(isLightTheme).textColor)
                      : Utilities.getTajwalTextStyleWithSize(14,
                      color:
                      themeProvider.themeColor(isLightTheme).textColor),
                )
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        }

        if (snapshot.data.size == 0) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  MyLocalization.of(context).getTranslatedValue("no_courses"),
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(14,
                      color:
                      themeProvider.themeColor(isLightTheme).textColor)
                      : Utilities.getTajwalTextStyleWithSize(14,
                      color:
                      themeProvider.themeColor(isLightTheme).textColor),
                )
              ],
            ),
          );
        }

        return ListView(
          padding: textDirection == TextDirection.ltr
              ? EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.5)
              : EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.5),
          children: snapshot.data.docs.map(
                (DocumentSnapshot document) {
              final currentCourse = document.get("course_title");
              // print(currentCourse);
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      currentCourse,
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(12,
                          color: themeProvider
                              .themeColor(isLightTheme)
                              .textColor)
                          : Utilities.getTajwalTextStyleWithSize(12,
                          color: themeProvider
                              .themeColor(isLightTheme)
                              .textColor),
                    ),
                  ),
                  SizedBox(
                    height: 0.5,
                    child: Container(color: Colors.grey),
                  ),
                ],
              );
            },
          ).toList(),
        );
      },
    );
  }
  static Widget getStudentLectures(ThemeProvider themeProvider,
      bool isLightTheme, TextDirection textDirection, courseID) {
    CollectionReference courses = FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
        .collection("lectures");

    return StreamBuilder<QuerySnapshot>(
      stream: courses.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                MyLocalization.of(context)
                    .getTranslatedValue("error_connection"),
                style: textDirection == TextDirection.ltr
                    ? Utilities.getUbuntuTextStyleWithSize(14,
                        color: themeProvider.themeColor(isLightTheme).textColor)
                    : Utilities.getTajwalTextStyleWithSize(14,
                        color:
                            themeProvider.themeColor(isLightTheme).textColor),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data.size == 0) {
          return Center(
            child: Text(
              MyLocalization.of(context)
                  .getTranslatedValue("no_lectures_student"),
              style: textDirection == TextDirection.ltr
                  ? Utilities.getUbuntuTextStyleWithSize(14,
                      color: themeProvider.themeColor(isLightTheme).textColor)
                  : Utilities.getTajwalTextStyleWithSize(14,
                      color: themeProvider.themeColor(isLightTheme).textColor),
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(vertical: 6),
          children: snapshot.data.docs.map(
            (DocumentSnapshot document) {
              final titleLecture = document.get("title");

              print(titleLecture);
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      titleLecture,
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(12,
                              color: themeProvider
                                  .themeColor(isLightTheme)
                                  .textColor)
                          : Utilities.getTajwalTextStyleWithSize(12,
                              color: themeProvider
                                  .themeColor(isLightTheme)
                                  .textColor),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return StudentLectureSteps(
                              courseID,
                              titleLecture,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 0.5,
                      child: Container(
                        color: isLightTheme ? Colors.grey : Colors.white54,
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        );
      },
    );
  }

  static showChoiceStepsIssuesDialog(courseID, lectureTitle, List titles,
      BuildContext context, bool isLightTheme, TextDirection textDirection,
      {String id}) {
    return showDialog(
      barrierColor: isLightTheme ? Colors.black54 : Colors.white10,
      context: context,
      builder: (context) {
        final _multipleNotifier = Provider.of<MultipleNotifier>(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 10,
          backgroundColor: isLightTheme
              ? AppTheme.lightTheme.backgroundColor
              : AppTheme.darkTheme.backgroundColor,
          title: Text(
            MyLocalization.of(context).getTranslatedValue("which_steps_title"),
            style: textDirection == TextDirection.ltr
                ? Utilities.getUbuntuTextStyleWithSize(16,
                    fontWeight: FontWeight.bold,
                    color: isLightTheme ? Colors.black : Colors.white)
                : Utilities.getTajwalTextStyleWithSize(16,
                    fontWeight: FontWeight.bold,
                    color: isLightTheme ? Colors.black : Colors.white),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: titles
                    .getRange(0, 5)
                    .map(
                      (e) => CheckboxListTile(
                        activeColor: HexColor("#5C704D"),
                        title: Text(
                          e,
                          style: textDirection == TextDirection.ltr
                              ? Utilities.getUbuntuTextStyleWithSize(12,
                                  color: isLightTheme
                                      ? Colors.black
                                      : Colors.white)
                              : Utilities.getTajwalTextStyleWithSize(12,
                                  color: isLightTheme
                                      ? Colors.black
                                      : Colors.white),
                        ),
                        onChanged: (value) {
                          value
                              ? _multipleNotifier.addItem(e)
                              : _multipleNotifier.removeItem(e);
                        },
                        value: _multipleNotifier.isHaveItem(e),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                elevation: 0,
                backgroundColor: HexColor("#A74552"),
              ),
              child: Text(
                MyLocalization.of(context).getTranslatedValue("cancel"),
                style: textDirection == TextDirection.ltr
                    ? Utilities.getUbuntuTextStyleWithSize(13)
                    : Utilities.getTajwalTextStyleWithSize(13),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              width: 10,
            ),
            TextButton(
              style: TextButton.styleFrom(
                elevation: 0,
                backgroundColor: HexColor("#5C704D"),
              ),
              child: Text(
                MyLocalization.of(context).getTranslatedValue("send"),
                style: textDirection == TextDirection.ltr
                    ? Utilities.getUbuntuTextStyleWithSize(12)
                    : Utilities.getTajwalTextStyleWithSize(12),
              ),
              onPressed: () async {
                if (id == "50Un4ErjskQVOrubCLzUloBsvHl1") {
                  Toast.show(
                    MyLocalization.of(context)
                        .getTranslatedValue("you_cannot_create_chatting"),
                    context,
                    duration: Toast.LENGTH_LONG,
                    gravity: Toast.BOTTOM,
                  );
                } else if(_multipleNotifier.selectedItems.isNotEmpty){
                  Map<String, dynamic> chatRoomInfoMap = {
                    "users": [
                      "crKMIHUqhrbBLzjtOsH1b10bnNx1",
                      "50Un4ErjskQVOrubCLzUloBsvHl1"
                    ]
                  };
                  String name = textDirection == TextDirection.ltr
                      ? "Abdullah Mohammad"
                      : "عبدالله محمد الغامدي";

                  await FirestoreDB.createChatRoom(
                    courseID,
                    chatRoomInfoMap,
                  );
                  List<String> mySelectedTitles =
                      _multipleNotifier.selectedItems;

                  print("mySelectedTitles = $mySelectedTitles");

                  for (int i = 0; i < mySelectedTitles.length; i++) {
                    addInitialMessages(courseID, mySelectedTitles[i]);
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        name,
                        courseID,
                        // listTitlesSelected: mySelectedTitles,
                      ),
                    ),
                  );
                }else{
                  Toast.show(
                    MyLocalization.of(context)
                        .getTranslatedValue("choose_something"),
                    context,
                    duration: Toast.LENGTH_LONG,
                    gravity: Toast.CENTER,
                  );
                  print("just ignore the clicked because the list is empty");
                }
              },
            ),
            SizedBox(
              width: 10,
            ),
          ],
        );
      },
    );
  }

  static addInitialMessages(courseID, String myTitles) {
    String messageID = Utilities.getRandomIdForNewCourse();
    print("myTitles = $myTitles");
    Map<String, dynamic> messageInfoMap = {
      "message": myTitles,
      "sendBy": "crKMIHUqhrbBLzjtOsH1b10bnNx1",
      "ts": DateTime.now(),
    };
    FirestoreDB.updateLastMessageSend(courseID, courseID, messageInfoMap);
    return FirestoreDB.addMessage(courseID, messageID, messageInfoMap);
  }
}
