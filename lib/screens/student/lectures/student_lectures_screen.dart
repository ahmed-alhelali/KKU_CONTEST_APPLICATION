import 'package:kku_contest_app/imports.dart';

class StudentLectureScreen extends StatefulWidget {
  final String title;
  final String id;

  const StudentLectureScreen({Key key, this.id, this.title}) : super(key: key);

  @override
  _StudentLectureScreenState createState() => _StudentLectureScreenState();
}

class _StudentLectureScreenState extends State<StudentLectureScreen> {
  String user1,user2;
  String chatRoomID;
  String imageForChatScreen,instructorName;


  getInfo() async {
    user2 = await FirebaseUtilities.getInstructorID();
    user1 = await FirebaseUtilities.getUserId();
    imageForChatScreen = await FirebaseUtilities.getInstructorImageUrl();
    instructorName = await FirebaseUtilities.getInstructorName();
    chatRoomID = "$user1\_$user2";
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
            // name = textDirection == TextDirection.ltr
            //     ? "Abdullah Mohammad"
            //     : "عبدالله محمد الغامدي";

            final snapShot = await FirebaseFirestore.instance
                .collection("Courses")
                .doc(widget.id)
                .collection("chats")
                .doc(chatRoomID)
                .get();

            print("CHT id $chatRoomID");
            if (snapShot.exists) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(imageForChatScreen, widget.id,chatRoomID,instructorName),
                ),
              );
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
          child: Icon(
            FontAwesomeIcons.solidCommentAlt,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
