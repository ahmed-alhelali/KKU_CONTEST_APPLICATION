import 'package:kku_contest_app/imports.dart';
import 'package:intl/intl.dart' as intl;

class ChatScreen extends StatefulWidget {
  final String imageForChatScreen, courseID, charRoomID, name, userID2;

  ChatScreen(this.imageForChatScreen, this.courseID, this.charRoomID, this.name,
      {this.userID2});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String messageID = "";
  List<String> myTitles;
  Stream messageStream;
  final messageController = TextEditingController();

  String userName;
  String userImageUrl;
  String userID;

  String name;
  String id;
  String imageUrl;


  readAllMessages(courseID,chatRoomID, uid,messagesID){

    FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
        .collection("chats")
        .doc(chatRoomID)
        .collection("my_chats").doc(messagesID).update({"read": true});


  }
  addMessage(bool sendClicked, uid) {
    print("user1 $userID");
    print("user2 $id");
    if (messageController.text != "") {
      String message = messageController.text;
      var lastMessage = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": uid,
        "ts": lastMessage,
        "read": false,
      };

      if (messageID == "") {
        messageID = Utilities.getRandomIdForNewCourse();
      }

      print("message added");
      FirestoreDB.addMessage(
        widget.courseID,
        widget.charRoomID,
        messageID,
        messageInfoMap,
      );
      print("message updated");
      FirestoreDB.updateLastMessageSend(
        widget.courseID,
        widget.charRoomID,
        messageInfoMap,
      );

      if (sendClicked) {
        messageController.text = "";
        messageID = "";

        print("USER @2 ${widget.userID2}");
        FirebaseFirestore.instance
            .collection("Courses")
            .doc(widget.courseID)
            .collection("chats")
            .doc(widget.charRoomID)
            .update({"read": false});
        if (uid != widget.userID2) {
          FirebaseFirestore.instance
              .collection("Courses")
              .doc(widget.courseID)
              .update({
            "notification": FieldValue.arrayUnion([widget.userID2]),
          });
        }
        if (widget.userID2 == userID) {
          FirebaseFirestore.instance
              .collection("Courses")
              .doc(widget.courseID)
              .update({
            "new_messages": FieldValue.arrayUnion([widget.userID2]),
          });
        }

        // FirebaseFirestore.instance
        //     .collection("Courses")
        //     .doc(widget.courseID)
        //     .update({"notification": true});
      }
    }
  }

  Widget chatMessageTile(
      String message, bool sendByMe, TextDirection textDirection, width, time,bool read) {
    DateTime d = time.toDate();

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
            : CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(widget.imageForChatScreen),
              ),
        Flexible(
          child: Container(
              margin: sendByMe
                  ? (textDirection == TextDirection.ltr
                      ? EdgeInsets.only(
                          left: width * 0.15, right: 10, top: 4, bottom: 4)
                      : EdgeInsets.only(
                          left: 10, right: width * 0.15, top: 4, bottom: 4))
                  : (textDirection == TextDirection.ltr
                      ? EdgeInsets.only(
                          left: 10, right: width * 0.15, top: 4, bottom:4)
                      : EdgeInsets.only(
                          left: width * 0.15, right: 10, top:4, bottom: 4)),

              // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                    ? (Theme.of(context).scaffoldBackgroundColor)
                    : (Theme.of(context).cardColor),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: sendByMe
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    // intl.DateFormat("hh:mm a").format(d).toString(),,
                    style: textDirection == TextDirection.ltr
                        ? Utilities.getUbuntuTextStyleWithSize(
                            12,
                            color: Theme.of(context).textTheme.caption.color,
                          )
                        : Utilities.getTajwalTextStyleWithSize(
                            13,
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  sendByMe ?
                  Wrap(
                    children: [
                      Text(
                        intl.DateFormat("hh:mm a").format(d).toString(),
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      sendByMe ?read? Icon(
                        Icons.done_all,
                        size: 12,
                        color: Colors.green,
                      ) :Icon(
                        Icons.done_all,
                        size: 12,
                      ) :
                          SizedBox() ,
                    ],
                  ) : Text(
                    intl.DateFormat("hh:mm a").format(d).toString(),
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.grey,
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              )),
        ),
      ],
    );
  }

  //
  // Align(
  // alignment: sendByMe
  // ? textDirection == TextDirection.ltr
  // ? Alignment.bottomLeft
  //     : Alignment.bottomRight
  //     : textDirection == TextDirection.ltr
  // ? Alignment.bottomRight
  //     : Alignment.bottomLeft,
  //
  // child: Text(
  // intl.DateFormat("hh:mm a").format(d).toString(),
  // style: Utilities.getUbuntuTextStyleWithSize(
  // 8,
  // color: Theme.of(context).textTheme.caption.color,
  // ),
  // ),
  // )
  Widget chatMessages(TextDirection textDirection) {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {

        var width = MediaQuery.of(context).size.width;
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {

                  DocumentSnapshot ds = snapshot.data.docs[index];
                  if(userID != ds["sendBy"]){
                    readAllMessages(widget.courseID,widget.charRoomID,userID,ds.reference.id);
                  }

                  return chatMessageTile(ds["message"], userID == ds["sendBy"],
                      textDirection, width, ds["ts"], ds["read"]);
                },
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await FirestoreDB.getChatRoomMessages(
        widget.courseID, widget.charRoomID);

    setState(() {});
  }

  getUserInfo() async {
    userName = await FirebaseUtilities.getUserName();
    userImageUrl = await FirebaseUtilities.getUserImageUrl();
    userID = await FirebaseUtilities.getUserId();
    name = await FirebaseUtilities.getInstructorName();
    id = await FirebaseUtilities.getInstructorID();
    imageUrl = await FirebaseUtilities.getInstructorImageUrl();
  }

  doThisOnLaunch() async {
    getUserInfo();
    getAndSetMessages();
  }

  @override
  void initState() {
    getUserInfo();
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

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        brightness: Theme.of(context).appBarTheme.brightness,
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.imageForChatScreen),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              widget.name,
              style: textDirection == TextDirection.ltr
                  ? Utilities.getUbuntuTextStyleWithSize(16,
                      color: Theme.of(context).textTheme.caption.color,
                      fontWeight: FontWeight.w600)
                  : Utilities.getTajwalTextStyleWithSize(16,
                      color: Theme.of(context).textTheme.caption.color,
                      fontWeight: FontWeight.w600),
            ),

          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(textDirection),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        minLines: 1,
                        maxLines: null,
                        controller: messageController,
                        style: textDirection == TextDirection.ltr
                            ? Utilities.getUbuntuTextStyleWithSize(
                                16,
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              )
                            : Utilities.getTajwalTextStyleWithSize(
                                16,
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                        decoration: InputDecoration(
                          isDense: true,
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
                          fillColor: Theme.of(context).backgroundColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.green.shade900,
                      ),
                      onPressed: () {
                        addMessage(
                          true,
                          userID,
                        );
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
