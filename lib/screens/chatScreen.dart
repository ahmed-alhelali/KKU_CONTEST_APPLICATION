import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kku_contest_app/FirebaseAPI/firestore.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/utilities/firebase_utilities.dart';
import 'package:kku_contest_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatWithUsername, courseID;
  // final List<String> listTitlesSelected;

  const ChatScreen(this.chatWithUsername, this.courseID,
);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String messageID = "";

  String instructorID = "50Un4ErjskQVOrubCLzUloBsvHl1";
  String studentID = "crKMIHUqhrbBLzjtOsH1b10bnNx1";
  List<String> myTitles;

  Stream messageStream;
  final messageController = TextEditingController();
  String myID;

  getInfoFromSharedPreference() async {
    myID = await FirebaseUtilities.getUserId();
  }

  getUserName() async {
    var userID = await FirebaseUtilities.getUserId();
    var Id = userID.toString();
    String IDtoString = Id.toString();
    return IDtoString;
  }

  // setInitMessages() {
  //   widget.listTitlesSelected.map(
  //     (e) => FirestoreDB.addMessage(
  //       widget.courseID,
  //       messageID,
  //       {
  //         "message": e.toString(),
  //         "sendBy": myID,
  //         "ts": DateTime.now(),
  //       },
  //     ),
  //   );
  // }

  addMessage(bool sendClicked) {
    if (messageController.text != "") {
      String message = messageController.text;
      var lastMessage = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myID,
        "ts": lastMessage,
      };

      if (messageID == "") {
        messageID = Utilities.getRandomIdForNewCourse();
      }

      print("message added");
      FirestoreDB.addMessage(
        widget.courseID,
        messageID,
        messageInfoMap,
      );
      print("message updated");
      FirestoreDB.updateLastMessageSend(
        widget.courseID,
        widget.courseID,
        messageInfoMap,
      );

      if (sendClicked) {
        messageController.text = "";
        messageID = "";
      }
    }
  }

  Widget chatMessageTile(
      String message,
      bool sendByMe,
      ThemeProvider themeProvider,
      TextDirection textDirection,
      bool isLightTheme) {
    return Row(
      textDirection: textDirection,
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: sendByMe ? 0 : 10,
        ),
        sendByMe
            ? SizedBox()
            : myID == instructorID
                ? CircleAvatar(
                    radius: 15,
                    backgroundImage:
                        ExactAssetImage("assets/images/student.png"),
                  )
                : CircleAvatar(
                    radius: 15,
                    backgroundImage:
                        ExactAssetImage("assets/images/instructor_avatar.jpg"),
                  ),
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: textDirection == TextDirection.ltr
                  ? BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                      bottomRight:
                          sendByMe ? Radius.circular(0) : Radius.circular(24),
                      bottomLeft:
                          sendByMe ? Radius.circular(24) : Radius.circular(0),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                      bottomRight:
                          sendByMe ? Radius.circular(24) : Radius.circular(0),
                      bottomLeft:
                          sendByMe ? Radius.circular(0) : Radius.circular(24),
                    ),
              color: sendByMe
                  ? (isLightTheme ? Colors.white : HexColor("#4a3b5e"))
                  : (isLightTheme ? Colors.grey.shade300 : HexColor("#2c2338")),
            ),
            padding: EdgeInsets.all(16),
            child: Text(
              message,
              style: textDirection == TextDirection.ltr
                  ? Utilities.getUbuntuTextStyleWithSize(13,
                      color: themeProvider.themeColor(isLightTheme).textColor)
                  : Utilities.getTajwalTextStyleWithSize(13,
                      color: themeProvider.themeColor(isLightTheme).textColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget chatMessages(ThemeProvider themeProvider, TextDirection textDirection,
      bool isLightTheme) {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMessageTile(
                    ds["message"],
                    myID == ds["sendBy"],
                    themeProvider,
                    textDirection,
                    isLightTheme,
                  );
                },
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await FirestoreDB.getChatRoomMessages(
      widget.courseID,
    );

    setState(() {});
  }

  doThisOnLaunch() async {
    await getInfoFromSharedPreference();
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.isDarkMode ? false : true;

    return Scaffold(
      backgroundColor: isLightTheme
          ? AppTheme.lightTheme.backgroundColor
          : AppTheme.darkTheme.backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        brightness: isLightTheme
            ? AppTheme.lightTheme.appBarTheme.brightness
            : AppTheme.darkTheme.appBarTheme.brightness,
        backgroundColor: isLightTheme
            ? AppTheme.lightTheme.backgroundColor
            : AppTheme.darkTheme.backgroundColor,
        iconTheme: isLightTheme
            ? AppTheme.lightTheme.appBarTheme.iconTheme
            : AppTheme.darkTheme.appBarTheme.iconTheme,
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            myID == instructorID
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        ExactAssetImage("assets/images/student.png"),
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        ExactAssetImage("assets/images/instructor_avatar.jpg"),
                  ),
            SizedBox(
              width: 15,
            ),
            Text(
              widget.chatWithUsername,
              style: textDirection == TextDirection.ltr
                  ? Utilities.getUbuntuTextStyleWithSize(16,
                      color: themeProvider.themeColor(isLightTheme).textColor,
                      fontWeight: FontWeight.w600)
                  : Utilities.getTajwalTextStyleWithSize(16,
                      color: themeProvider.themeColor(isLightTheme).textColor,
                      fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(themeProvider, textDirection, isLightTheme),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: isLightTheme
                    ? AppTheme.lightTheme.scaffoldBackgroundColor
                    : AppTheme.darkTheme.scaffoldBackgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          controller: messageController,
                          style: textDirection == TextDirection.ltr
                              ? Utilities.getUbuntuTextStyleWithSize(16,
                                  color: themeProvider
                                      .themeColor(isLightTheme)
                                      .textColor)
                              : Utilities.getTajwalTextStyleWithSize(16,
                                  color: themeProvider
                                      .themeColor(isLightTheme)
                                      .textColor),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35),
                                borderSide: BorderSide.none),
                            hintText: MyLocalization.of(context)
                                .getTranslatedValue("type_message"),
                            hintStyle: textDirection == TextDirection.ltr
                                ? Utilities.getUbuntuTextStyleWithSize(14,
                                    color: Colors.grey)
                                : Utilities.getTajwalTextStyleWithSize(14,
                                    color: Colors.grey),
                            filled: true,
                            fillColor: isLightTheme
                                ? Colors.grey.shade100
                                : HexColor("#362b45"),
                            // hintStyle: TextStyle(
                            //   color: isLightTheme ? Colors.black : Colors.grey,
                            // ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.green.shade900,
                      ),
                      onPressed: () {
                        addMessage(true);
                        // print(widget.listTitlesSelected);
                        // setInitMessages();
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
