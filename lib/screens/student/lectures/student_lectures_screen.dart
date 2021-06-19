import 'package:kku_contest_app/imports.dart';

class StudentLectureScreen extends StatefulWidget {
  final String title;
  final String id;

  const StudentLectureScreen({Key key, this.id, this.title}) : super(key: key);

  @override
  _StudentLectureScreenState createState() => _StudentLectureScreenState();
}

class _StudentLectureScreenState extends State<StudentLectureScreen> {
  String user1, user2;
  String chatRoomID;
  String imageForChatScreen, instructorName;
  DocumentSnapshot snapShot2;


  getInfo() async {
    user2 = await FirebaseUtilities.getInstructorID();
    user1 = await FirebaseUtilities.getUserId();
    imageForChatScreen = await FirebaseUtilities.getInstructorImageUrl();
    instructorName = await FirebaseUtilities.getInstructorName();
    chatRoomID = "$user1\_$user2";
    snapShot2 = await FirebaseFirestore.instance
        .collection("Courses")
        .doc(widget.id)
        .collection("chats")
        .doc(chatRoomID)
        .get();
  }

  @override
  void initState() {
    getInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        brightness: Theme.of(context).appBarTheme.brightness,
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        title: Text(
          widget.title.toUpperCase(),
          style: textDirection == TextDirection.ltr
              ? Utilities.getUbuntuTextStyleWithSize(
                  16,
                  color: Theme.of(context).textTheme.caption.color,
                )
              : Utilities.getTajwalTextStyleWithSize(
                  16,
                  color: Theme.of(context).textTheme.caption.color,
                ),
        ),
      ),
      body:
          StudentWidgets.getStudentLectures(context, textDirection, widget.id),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(6),
        child: FloatingActionButton(
          highlightElevation: 0,
          elevation: 0,
          backgroundColor: Colors.green.shade800,
          onPressed: () async {
            var removedNotification = [user1];

            FirebaseFirestore.instance
                .collection("Courses")
                .doc(widget.id)
                .update({
              "notification": FieldValue.arrayRemove(removedNotification)
            });

            final snapShotx = await FirebaseFirestore.instance
                .collection("Courses")
                .doc(widget.id)
                .collection("chats")
                .doc(chatRoomID)
                .get();

            if (snapShotx.exists) {
              // FirebaseFirestore.instance
              //     .collection("Courses")
              //     .doc(widget.id)
              //     .update({"notification": false});
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(imageForChatScreen,
                      widget.id, chatRoomID, instructorName,userID2: user1,),
                ),
              ).then((value) {
                if (snapShotx.get("sendBy") != user1) {
                  FirebaseFirestore.instance
                      .collection("Courses")
                      .doc(widget.id)
                      .collection("chats")
                      .doc(chatRoomID)
                      .update({"read": true});
                }
              });
            } else {
              Widgets.showWarringDialog(
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
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Courses")
                .doc(widget.id)
                .collection("chats")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Icon(
                  FontAwesomeIcons.solidCommentAlt,
                  size: 30,
                  color: Colors.white,
                );
              if (snapshot.data.size > 0) {
                return Stack(
                  alignment: Alignment.center,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    if (document.get("user") == user1) {
                      if (document.get("sendBy") != user1) {
                        if (document.get("read") == false)
                          return Stack(
                            children: [
                              Icon(
                                FontAwesomeIcons.solidCommentAlt,
                                size: 30,
                                color: Colors.white,
                              ),
                              Transform.translate(
                                offset: textDirection == TextDirection.ltr
                                    ? Offset(-10, -10)
                                    : Offset(10, -10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red.shade900,
                                      borderRadius: BorderRadius.circular(20)),
                                  height: 15,
                                  width: 15,
                                ),
                              )
                            ],
                          );
                        return Icon(
                          FontAwesomeIcons.solidCommentAlt,
                          size: 30,
                          color: Colors.white,
                        );
                      }
                      return Icon(
                        FontAwesomeIcons.solidCommentAlt,
                        size: 30,
                        color: Colors.white,
                      );
                    }
                    return Icon(
                      FontAwesomeIcons.solidCommentAlt,
                      size: 30,
                      color: Colors.white,
                    );
                  }).toList(),
                );
              }

              return Icon(
                FontAwesomeIcons.solidCommentAlt,
                size: 30,
                color: Colors.white,
              );
            },
          ),
        ),
      ),
    );
  }
}
