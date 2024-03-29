import 'package:connected/imports.dart';

class InstructorWidgets {
  static Widget getInstructorCourses(TextDirection textDirection, String uid,
      {chatRoomID}) {
    CollectionReference courses =
        FirebaseFirestore.instance.collection("Courses");
    final slidableController = new SlidableController();
    String courseID;
    return StreamBuilder<QuerySnapshot>(
      stream: courses.where("uid", isEqualTo: uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(
            MyLocalization.of(context).getTranslatedValue("error_connection"),
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
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(vertical: 6),
          children: snapshot.data.docs.map(
            (DocumentSnapshot document) {
              // document.reference.collection("chats").doc("ssEIbH0lzJhaiEx7LMKBRoUuhQk1_6nUQ2qDbFYVxT2JBZeYFH7VYPZn1").get()

              List<dynamic> newMessages = document.get("new_messages");

              final currentCourse = document.get("course_title");
              return Slidable(
                child: InkWell(
                  child: Container(
                    alignment: AlignmentDirectional.centerStart,
                    // padding: EdgeInsets.symmetric(horizontal: 30),
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.09,
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
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
                        newMessages.length > 0
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade900,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    newMessages.length.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                    textAlign: TextAlign.center,
                                  ),
                                  height: 20,
                                  // width: 20,
                                ))
                            : Center(),
                      ],
                    ),
                    // child: Text(
                    //   currentCourse,
                    //   style: textDirection == TextDirection.ltr
                    //       ? Utilities.getUbuntuTextStyleWithSize(
                    //           16,
                    //           color: Theme.of(context).textTheme.caption.color,
                    //         )
                    //       : Utilities.getTajwalTextStyleWithSize(
                    //           16,
                    //           color: Theme.of(context).textTheme.caption.color,
                    //         ),
                    // ),
                  ),
                  onTap: () {
                    courseID = document.id;
                    FirebaseUtilities.saveInstructorID(document.get("uid"));

                    // print(courseID);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InstructorCourse(
                          id: courseID,
                          courseTitle: currentCourse,
                          uid: uid,
                        ),
                      ),
                    );
                  },
                ),
                actionPane: SlidableStrechActionPane(),
                controller: slidableController,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: IconSlideAction(
                        caption: MyLocalization.of(context)
                            .getTranslatedValue("delete"),
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          Widgets.showWarringDialog(
                            "are_you_sure",
                            "delete_course_warring",
                            context,
                            "delete",
                            "cancel",
                            textDirection,
                            functionOfYesButton: () {
                              FirestoreDB.deleteCourse(document.id);
                              Navigator.pop(context);
                            },
                            functionOfNoButton: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: IconSlideAction(
                        caption: MyLocalization.of(context)
                            .getTranslatedValue("get_id"),
                        color: Colors.green.shade800,
                        icon: FontAwesomeIcons.link,
                        onTap: () {
                          // print(document.id);
                          Clipboard.setData(ClipboardData(text: document.id))
                              .then((value) {
                            final snackBar = SnackBar(
                              elevation: 0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              content: Text(
                                MyLocalization.of(context)
                                    .getTranslatedValue("course_id_copied"),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
                              ),
                              action: SnackBarAction(
                                textColor:
                                    Theme.of(context).textTheme.caption.color,
                                label: MyLocalization.of(context)
                                    .getTranslatedValue("close"),
                                onPressed: () {},
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        },
                      ),
                    ),
                  ),
                ],
                secondaryActions: [],
              );
            },
          ).toList(),
        );
      },
    );
  }

  static addCourseWidget(
      TextDirection textDirection,
      BuildContext context,
      TextEditingController titleController,
      String uid,
      String userImage,
      String userName) {
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      elevation: 10,
      barrierColor: Theme.of(context).shadowColor,
      enableDrag: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      builder: (context) {
        return Container(
          //this line fix hiding the bottomSheet behind the keyboard issue
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),

          height: 230,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: 150,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  Text(
                    MyLocalization.of(context)
                        .getTranslatedValue("create_course"),
                    style: textDirection == TextDirection.ltr
                        ? Utilities.getUbuntuTextStyleWithSize(
                            18,
                            color: Theme.of(context).textTheme.caption.color,
                          )
                        : Utilities.getTajwalTextStyleWithSize(
                            18,
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      child: TextFormField(
                        controller: titleController,
                        cursorColor: Theme.of(context).canvasColor,
                        style: textDirection == TextDirection.ltr
                            ? Utilities.getUbuntuTextStyleWithSize(
                                14,
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              )
                            : Utilities.getTajwalTextStyleWithSize(
                                14,
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                        decoration: InputDecoration(
                          contentPadding: textDirection == TextDirection.ltr
                              ? EdgeInsets.only(left: 30)
                              : EdgeInsets.only(right: 30),
                          labelText: MyLocalization.of(context)
                              .getTranslatedValue("course_name"),
                          labelStyle: textDirection == TextDirection.ltr
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey,
                            ),
                            onPressed: () => titleController.clear(),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return MyLocalization.of(context)
                                .getTranslatedValue("validate_title");
                          }
                          return null;
                        },
                        maxLength: 37,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 15,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 100,
                          child: FloatingActionButton.extended(
                            // elevation: 0,
                            // highlightElevation: 0,
                            label: Text(
                              MyLocalization.of(context)
                                  .getTranslatedValue("cancel"),
                              style: TextStyle(color: Colors.white),
                            ),
                            // backgroundColor: HexColor("#A74552"),
                            backgroundColor: Colors.red.shade600,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: FloatingActionButton.extended(
                            elevation: 0,
                            highlightElevation: 0,
                            label: Text(
                              MyLocalization.of(context)
                                  .getTranslatedValue("create"),
                              style: TextStyle(color: Colors.white),
                            ),
                            // backgroundColor: HexColor("#5C704D"),
                            backgroundColor: Colors.green.shade800,
                            onPressed: () async {
                              CollectionReference newCourse = FirebaseFirestore
                                  .instance
                                  .collection("Courses");

                              if (formKey.currentState.validate()) {
                                var response = await newCourse
                                    .where("course_title",
                                        isEqualTo: titleController.text)
                                    .snapshots()
                                    .first;
                                if (response.docs.length > 0) {
                                  Toast.show(
                                    MyLocalization.of(context)
                                        .getTranslatedValue(
                                            "course_already_exist"),
                                    context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.CENTER,
                                  );
                                } else {
                                  FirestoreDB.addCourse(titleController.text,
                                      uid, userImage, userName);
                                  titleController.text = "";
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget getInstructorCoursesInDrawer(
      TextDirection textDirection, String uid) {
    CollectionReference courses =
        FirebaseFirestore.instance.collection("Courses");

    return StreamBuilder<QuerySnapshot>(
      stream: courses.where("uid", isEqualTo: uid).snapshots(),
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

  static Widget getInstructorLectures(
      TextDirection textDirection, courseID, String uid) {
    final lectureSlidableController = new SlidableController();
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
                        color: Colors.red)
                    : Utilities.getTajwalTextStyleWithSize(14),
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
                  .getTranslatedValue("no_lectures_instructor"),
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
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
          children: snapshot.data.docs.map(
            (DocumentSnapshot document) {
              final titleLecture = document.get("title");
              // print(titleLecture);
              return Padding(
                padding: EdgeInsets.only(top: 5),
                child: Slidable(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          titleLecture,
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
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 25,
                          ),
                          onPressed: () {
                            FirestoreDB.deleteAllStepsUnderLecture(
                                courseID, titleLecture);
                            FirestoreDB.deleteLecture(courseID, titleLecture);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          height: 0.5,
                          child: Container(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  actionPane: SlidableStrechActionPane(),
                  controller: lectureSlidableController,
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: IconSlideAction(
                          caption: MyLocalization.of(context)
                              .getTranslatedValue("review"),
                          color: Colors.green.shade800,
                          icon: Icons.pageview,
                          onTap: () {
                            Widgets.showWarringDialog(
                              "do_not_sent_message_title",
                              "do_not_sent_message_content",
                              context,
                              "logout",
                              "i_get_it",
                              textDirection,
                              functionOfNoButton: () {
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
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }

  static Widget getColumnOfTextFields(BuildContext context,
      TextDirection textDirection, titleController, descriptionController) {
    return Column(
      children: [
        TextField(
          controller: titleController,
          style: textDirection == TextDirection.ltr
              ? Utilities.getUbuntuTextStyleWithSize(
                  12,
                  color: Theme.of(context).textTheme.caption.color,
                )
              : Utilities.getTajwalTextStyleWithSize(
                  12,
                  color: Theme.of(context).textTheme.caption.color,
                ),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintStyle: textDirection == TextDirection.ltr
                ? Utilities.getUbuntuTextStyleWithSize(12, color: Colors.grey)
                : Utilities.getTajwalTextStyleWithSize(12, color: Colors.grey),
            hintText: MyLocalization.of(context).getTranslatedValue("title"),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: descriptionController,
          style: textDirection == TextDirection.ltr
              ? Utilities.getUbuntuTextStyleWithSize(
                  12,
                  color: Theme.of(context).textTheme.caption.color,
                )
              : Utilities.getTajwalTextStyleWithSize(
                  12,
                  color: Theme.of(context).textTheme.caption.color,
                ),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintStyle: textDirection == TextDirection.ltr
                ? Utilities.getUbuntuTextStyleWithSize(12, color: Colors.grey)
                : Utilities.getTajwalTextStyleWithSize(12, color: Colors.grey),
            hintText:
                MyLocalization.of(context).getTranslatedValue("description"),
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  static Widget getChildForTab(
      BuildContext context, String titleKey, TextDirection textDirection) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: Colors.redAccent, width: 1)
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          MyLocalization.of(context).getTranslatedValue(titleKey),
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
    );
  }
}
