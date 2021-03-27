import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kku_contest_app/FirebaseAPI/firestore.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/screens/chatScreen.dart';
import 'package:kku_contest_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

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

  Widget chatRoomsList(TextDirection textDirection, ThemeProvider themeProvider,
      bool isLightTheme) {
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
                  .getTranslatedValue("no_student_ask_help"),
              style: textDirection == TextDirection.ltr
                  ? Utilities.getUbuntuTextStyleWithSize(14,
                      color: themeProvider.themeColor(isLightTheme).textColor)
                  : Utilities.getTajwalTextStyleWithSize(14,
                      color: themeProvider.themeColor(isLightTheme).textColor),
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
                              color: themeProvider
                                  .themeColor(isLightTheme)
                                  .textColor,
                              fontWeight: FontWeight.w600)
                          : Utilities.getTajwalTextStyleWithSize(14,
                              color: themeProvider
                                  .themeColor(isLightTheme)
                                  .textColor,
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

  @override
  void initState() {
    getChatRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.isDarkMode ? false : true;

    return Scaffold(
      backgroundColor: isLightTheme
          ? AppTheme.lightTheme.scaffoldBackgroundColor
          : AppTheme.darkTheme.scaffoldBackgroundColor,
      body: chatRoomsList(textDirection, themeProvider, isLightTheme),
    );
  }
}
