import 'package:kku_contest_app/imports.dart';

class HelpStudentScreen extends StatefulWidget {
  final String id, lectureTitle;

  const HelpStudentScreen({Key key, this.id, this.lectureTitle})
      : super(key: key);

  @override
  _HelpStudentScreenState createState() => _HelpStudentScreenState();
}

class _HelpStudentScreenState extends State<HelpStudentScreen> {
  Stream chatRoomsStream;

  getChatRooms() async {
    chatRoomsStream = await FirestoreDB.getChatRooms(widget.id);

    setState(() {});
  }

  Widget chatRoomsList(TextDirection textDirection) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Courses")
          .doc(widget.id)
          .collection("chats")
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
                    ? Utilities.getUbuntuTextStyleWithSize(14,
                        color: Theme.of(context).textTheme.caption.color,)
                    : Utilities.getTajwalTextStyleWithSize(14,
                        color:
                        Theme.of(context).textTheme.caption.color,),
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
                  ? Utilities.getUbuntuTextStyleWithSize(14,
                      color: Theme.of(context).textTheme.caption.color,)
                  : Utilities.getTajwalTextStyleWithSize(14,
                      color: Theme.of(context).textTheme.caption.color,),
              textAlign: TextAlign.center,
            ),
          );
        }

        String name = textDirection == TextDirection.ltr
            ? "Ahmed Ali A Alhelali"
            : "أحمد علي الهلالي";

        return ListView(
          padding: EdgeInsets.symmetric(vertical: 6),
          children: snapshot.data.docs.map(
            (DocumentSnapshot document) {
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          ExactAssetImage("assets/images/student.png"),
                    ),
                    title: Text(
                      name,
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(14,
                              color: Theme.of(context).textTheme.caption.color,
                              fontWeight: FontWeight.w600)
                          : Utilities.getTajwalTextStyleWithSize(14,
                              color: Theme.of(context).textTheme.caption.color,
                              fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      document.get("message").toString(),
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(10,
                              color: Colors.grey.shade600)
                          : Utilities.getTajwalTextStyleWithSize(10,
                              color: Colors.grey.shade600),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ChatScreen(name, widget.id);
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
                        color: Colors.red,
                        // color: isLightTheme ? Colors.grey : Colors.white54,
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
