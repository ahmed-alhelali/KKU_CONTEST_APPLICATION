import 'package:connected/imports.dart';

class StudentWidgets {
  static Widget getStudentCourses(TextDirection textDirection, String id) {
    CollectionReference courses =
        FirebaseFirestore.instance.collection("Courses");
    String courseID;

    return StreamBuilder<QuerySnapshot>(
      stream:
          courses.where("access_by_students", arrayContains: id).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(
            MyLocalization.of(context).getTranslatedValue("error_connection"),
            style: textDirection == TextDirection.ltr
                ? Utilities.getUbuntuTextStyleWithSize(
                    14,
                    color: Theme.of(context).textTheme.caption.color,
                  )
                : Utilities.getTajwalTextStyleWithSize(
                    14,
                    color: Theme.of(context).textTheme.caption.color,
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                MyLocalization.of(context)
                    .getTranslatedValue("no_courses_student"),
                style: textDirection == TextDirection.ltr
                    ? Utilities.getUbuntuTextStyleWithSize(
                        14,
                        color: Theme.of(context).textTheme.caption.color,
                      )
                    : Utilities.getTajwalTextStyleWithSize(
                        14,
                        color: Theme.of(context).textTheme.caption.color,
                      ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(vertical: 6),
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            List<dynamic> users = document.get("new_access");
            List<dynamic> notification = document.get("notification");

            final currentCourse = document.get("course_title");
            return InkWell(
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.09,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            currentCourse,
                            style: textDirection == TextDirection.ltr
                                ? Utilities.getUbuntuTextStyleWithSize(
                                    16,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  )
                                : Utilities.getTajwalTextStyleWithSize(
                                    16,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                          ),
                        ),
                        notification.contains(id)
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.red.shade900,
                                      borderRadius: BorderRadius.circular(20)),
                                  height: 15,
                                  width: 15,
                                ))
                            : Center(),
                      ],
                    ),
                    users.contains(id)
                        ? Positioned(
                            right:
                                textDirection == TextDirection.ltr ? 0.9 : null,
                            top: 10,
                            left:
                                textDirection == TextDirection.ltr ? null : 0.9,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "New Course",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.red.shade900,
                                  borderRadius:
                                      textDirection == TextDirection.ltr
                                          ? BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                            )
                                          : BorderRadius.only(
                                              bottomRight: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            )),
                              height: 20,
                              width: 80,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              onTap: () {
                FirebaseUtilities.saveInstructorName(document.get("name"));
                FirebaseUtilities.saveInstructorID(document.get("uid"));
                FirebaseUtilities.saveInstructorImageUrl(
                    document.get("imageUrl"));
                courseID = document.id;
                print(courseID);

                var removed = [id];
                FirebaseFirestore.instance
                    .collection("Courses")
                    .doc(courseID)
                    .update({"new_access": FieldValue.arrayRemove(removed)});

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

  static Widget getStudentCoursesInDrawer(
      TextDirection textDirection, String uid) {
    CollectionReference courses =
        FirebaseFirestore.instance.collection("Courses");

    return StreamBuilder<QuerySnapshot>(
      stream:
          courses.where("access_by_students", arrayContains: uid).snapshots(),
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
                      ? Utilities.getUbuntuTextStyleWithSize(
                          14,
                          color: Theme.of(context).textTheme.caption.color,
                        )
                      : Utilities.getTajwalTextStyleWithSize(
                          14,
                          color: Theme.of(context).textTheme.caption.color,
                        ),
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
                      ? Utilities.getUbuntuTextStyleWithSize(
                          14,
                          color: Theme.of(context).textTheme.caption.color,
                        )
                      : Utilities.getTajwalTextStyleWithSize(
                          14,
                          color: Theme.of(context).textTheme.caption.color,
                        ),
                )
              ],
            ),
          );
        }

        return ListView(
          padding: textDirection == TextDirection.ltr
              ? EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.45)
              : EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.45),
          children: snapshot.data.docs.map(
            (DocumentSnapshot document) {
              final currentCourse = document.get("course_title");
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      currentCourse,
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(
                              12,
                              color: Theme.of(context).textTheme.caption.color,
                            )
                          : Utilities.getTajwalTextStyleWithSize(
                              12,
                              color: Theme.of(context).textTheme.caption.color,
                            ),
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

  static Widget getStudentLectures(
      BuildContext context, TextDirection textDirection, courseID) {
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
                    ? Utilities.getUbuntuTextStyleWithSize(
                        14,
                        color: Theme.of(context).textTheme.caption.color,
                      )
                    : Utilities.getTajwalTextStyleWithSize(
                        14,
                        color: Theme.of(context).textTheme.caption.color,
                      ),
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
                  ? Utilities.getUbuntuTextStyleWithSize(
                      14,
                      color: Theme.of(context).textTheme.caption.color,
                    )
                  : Utilities.getTajwalTextStyleWithSize(
                      14,
                      color: Theme.of(context).textTheme.caption.color,
                    ),
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
                          ? Utilities.getUbuntuTextStyleWithSize(
                              12,
                              color: Theme.of(context).textTheme.caption.color,
                            )
                          : Utilities.getTajwalTextStyleWithSize(
                              12,
                              color: Theme.of(context).textTheme.caption.color,
                            ),
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
                        // color: isLightTheme ? Colors.grey : Colors.white54,
                        color: Theme.of(context).dividerColor,
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
      BuildContext context, TextDirection textDirection,
      {String id}) async {
    String userName = await FirebaseUtilities.getUserName();
    String imageUrl = await FirebaseUtilities.getUserImageUrl();
    String imageForChatScreen = await FirebaseUtilities.getInstructorImageUrl();
    String userID1 = await FirebaseUtilities.getUserId();
    String userID2 = await FirebaseUtilities.getInstructorID();
    String instructorName = await FirebaseUtilities.getInstructorName();

    return showDialog(
      barrierColor: Theme.of(context).shadowColor,
      context: context,
      builder: (context) {
        final _multipleNotifier = Provider.of<MultipleNotifier>(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            MyLocalization.of(context).getTranslatedValue("which_steps_title"),
            style: textDirection == TextDirection.ltr
                ? Utilities.getUbuntuTextStyleWithSize(
                    16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.caption.color,
                  )
                : Utilities.getTajwalTextStyleWithSize(
                    16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.caption.color,
                  ),
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
                              ? Utilities.getUbuntuTextStyleWithSize(
                                  12,
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                )
                              : Utilities.getTajwalTextStyleWithSize(
                                  12,
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
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
                } else if (_multipleNotifier.selectedItems.isNotEmpty) {
                  Map<String, dynamic> chatRoomInfoMap = {
                    "users": [userID1, userID2]
                  };

                  String chatRoomID = "$userID1\_$userID2";

                  await FirestoreDB.createChatRoom(
                    courseID,
                    chatRoomID,
                    chatRoomInfoMap,
                  );
                  List<String> mySelectedTitles =
                      _multipleNotifier.selectedItems;

                  print("mySelectedTitles = $mySelectedTitles");

                  if(imageUrl != null && userName != null){
                    for (int i = 0; i < mySelectedTitles.length; i++) {
                      addInitialMessages(courseID, chatRoomID,
                          mySelectedTitles[i], userID1, userName, imageUrl);
                    }


                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(imageForChatScreen,
                            courseID, chatRoomID, instructorName,userID2: userID2,otherSideUserID: userID2,),
                      ),
                    );
                  }


                } else {
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

  static addInitialMessages(courseID, String chatRoomID, String myTitles,
      String userID, name, imageUrl) {
    String messageID = Utilities.getRandomIdForNewCourse();
    print("myTitles = $myTitles");

    Map<String, dynamic> messageInfoMap = {
      "message": myTitles,
      "sendBy": userID,
      "user": userID,
      "name": name,
      "image_url": imageUrl,
      "read": false,
      "ts": DateTime.now(),
    };
    Map<String, dynamic> messageMap = {
      "message": myTitles,
      "sendBy": userID,
      "read": false,
      "ts": DateTime.now(),
    };


    FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
        .update({
      "new_messages": FieldValue.arrayUnion([userID]),
    });
    FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
        .collection("chats")
        .doc(chatRoomID)
        .collection("my_chats")
        .doc("sendBy").set({ "sendBy": userID});

    FirestoreDB.updateLastMessageSend(courseID, chatRoomID, messageInfoMap,sendBy: userID);
    return FirestoreDB.addMessage(courseID, chatRoomID, messageID, messageMap);

  }
}
