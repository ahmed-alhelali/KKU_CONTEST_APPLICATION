import 'package:kku_contest_app/imports.dart';
import 'package:intl/intl.dart' as intl;

class HelpStudentScreen extends StatefulWidget {
  final String id, lectureTitle;

  const HelpStudentScreen({Key key, this.id, this.lectureTitle})
      : super(key: key);

  @override
  _HelpStudentScreenState createState() => _HelpStudentScreenState();
}

class _HelpStudentScreenState extends State<HelpStudentScreen> {
  Stream chatRoomsStream;
  var currentUserID;

  getChatRooms() async {
    chatRoomsStream = await FirestoreDB.getChatRooms(widget.id);
    currentUserID = await FirebaseUtilities.getUserId();

  }




  Widget chatRoomsList(TextDirection textDirection) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Courses")
          .doc(widget.id)
          .collection("chats")
          .orderBy("ts", descending: true)
          .snapshots(),
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
                  .getTranslatedValue("no_student_ask_help"),
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
              Timestamp t = document['ts'];
              DateTime d = t.toDate();
              return Column(
                children: [
                  ListTile(
                    leading: document.get("image_url") != null ? CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(document.get("image_url")),
                    ) : CircleAvatar(
                      radius: 20,
                      backgroundImage: ExactAssetImage("assets/images/instructor_avatar.jpg"),
                    ) ,
                    title: Text(
                      document.get("name"),
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(14,
                              color: Theme.of(context).textTheme.caption.color,
                              fontWeight: FontWeight.w600)
                          : Utilities.getTajwalTextStyleWithSize(14,
                              color: Theme.of(context).textTheme.caption.color,
                              fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      document.get("sendBy") == currentUserID ? "You: ${document.get("message").toString().substring(0,50) + "..."}" :document.get("message").toString().substring(0,50) + "...",
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(10,
                              color: Colors.grey.shade600)
                          : Utilities.getTajwalTextStyleWithSize(10,
                              color: Colors.grey.shade600),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          intl.DateFormat("hh:mm a").format(d).toString(),
                          style: TextStyle(fontSize: 12),
                          textDirection: TextDirection.ltr,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        document.get("sendBy") == currentUserID
                            ? Container(
                                child: Text(""),
                              )
                            : document.get("read") == false
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red.shade900,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    height: 15,
                                    width: 15,
                                  )
                                : Container(
                                    child: Text(""),
                                  ),
                      ],
                    ),
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection("Courses")
                          .doc(widget.id)
                          .update({
                        "new_messages": FieldValue.arrayRemove([document.get("user")]),
                      });
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ChatScreen(document.get("image_url"),
                                widget.id, document.id, document.get("name"),userID2: document.get("user"),);
                          },
                        ),
                      );
                      if (document.get("sendBy") != currentUserID) {
                        FirebaseFirestore.instance
                            .collection("Courses")
                            .doc(widget.id)
                            .collection("chats")
                            .doc(document.id)
                            .update({"read": true});
                      }
                    },
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
              );
            },
          ).toList(),
        );
      },
    );
  }

  @override
  void initState() {
    getChatRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: chatRoomsList(textDirection),
    );
  }
}
