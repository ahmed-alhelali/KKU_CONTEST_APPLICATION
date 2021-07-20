import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

// import 'package:image_picker/image_picker.dart';
import 'package:connected/imports.dart';
import 'package:intl/intl.dart' as intl;

// import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;

class ChatScreen extends StatefulWidget {
  final String imageForChatScreen,
      courseID,
      charRoomID,
      name,
      userID2,
      student,
      otherSideUserID;

  ChatScreen(this.imageForChatScreen, this.courseID, this.charRoomID, this.name,
      {this.userID2, this.student, this.otherSideUserID});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String messageID = "";
  Stream messageStream;
  TextEditingController messageController;

  String userName;
  String userImageUrl;
  String userID;

  String name;
  String instructorID;
  String imageUrl;

  File _image;
  String _uploadedFileURL;

  readAllNewMessages(courseID, chatRoomID, uid, messagesID) {
    print("READS");
    FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
        .collection("chats")
        .doc(chatRoomID)
        .collection("my_chats")
        .doc(messagesID)
        .update({"read": true});
  }

  addMessage(bool sendClicked, uid) {
    print(userID);
    print(widget.userID2);
    print(instructorID);
    if (messageController.text != "") {
      String message = messageController.text.trim();
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
          widget.courseID, widget.charRoomID, messageInfoMap,
          sendBy: uid);

      if (sendClicked) {
        messageController.text = "";
        _clear();

        print(messageController.text.length);
        messageID = "";

        FirebaseFirestore.instance
            .collection("Courses")
            .doc(widget.courseID)
            .collection("chats")
            .doc(widget.charRoomID)
            .update({"read": false});

        if (uid == instructorID) {
          FirebaseFirestore.instance
              .collection("Courses")
              .doc(widget.courseID)
              .update({
            "notification": FieldValue.arrayUnion([widget.student]),
          });
        }
        if (uid != instructorID) {
          FirebaseFirestore.instance
              .collection("Courses")
              .doc(widget.courseID)
              .update({
            "new_messages": FieldValue.arrayUnion([userID]),
          });
        }
      }
    }
  }

  Widget chatMessageTile(String message, bool sendByMe,
      TextDirection textDirection, width, time, bool read) {
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
                left: 10, right: width * 0.15, top: 4, bottom: 4)
                : EdgeInsets.only(
                left: width * 0.15, right: 10, top: 4, bottom: 4)),

            // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: textDirection == TextDirection.ltr
                  ? BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight:
                sendByMe ? Radius.circular(0) : Radius.circular(15),
                bottomLeft:
                sendByMe ? Radius.circular(15) : Radius.circular(0),
              )
                  : BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight:
                sendByMe ? Radius.circular(15) : Radius.circular(0),
                bottomLeft:
                sendByMe ? Radius.circular(0) : Radius.circular(15),
              ),
              color: sendByMe
                  ? (Theme
                  .of(context)
                  .scaffoldBackgroundColor)
                  : (Theme
                  .of(context)
                  .cardColor),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment:
              sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  // intl.DateFormat("hh:mm a").format(d).toString(),,
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(
                    12,
                    color: Theme
                        .of(context)
                        .textTheme
                        .caption
                        .color,
                  )
                      : Utilities.getTajwalTextStyleWithSize(
                    13,
                    color: Theme
                        .of(context)
                        .textTheme
                        .caption
                        .color,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                sendByMe
                    ? Wrap(
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
                    sendByMe
                        ? read
                        ? Icon(
                      Icons.done_all,
                      size: 12,
                      color: Colors.green,
                    )
                        : Icon(
                      Icons.done_all,
                      size: 12,
                    )
                        : SizedBox(),
                  ],
                )
                    : Text(
                  intl.DateFormat("hh:mm a").format(d).toString(),
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.grey,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Future chooseFile() async {
    ImagePicker picker = ImagePicker();
    PickedFile image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((image) {
      setState(() {
        _image = image as File;
        uploadFile();
      });
    });

    // await picker.getImage(source: ImageSource.gallery).then((image) {
    //
    // });
  }
  Future<void> _sendImage(List<int> imageData) async {
    setState(() {
      // _isImageOptionClicked = !_isImageOptionClicked;
      // _isSendingImages = true;
    });
    // final result = await _uplaodImageToServer(imageData);

    // final message = Message(
    //   idFrom: userId,
    //   idTo: widget.peerId,
    //   content: result['url'],
    //   type: MessageType.image,
    //   isRead: false,
    //   timestamp: result['fileName'],
    // );

    // await _sendMessage(message);

    // _isSendingImages = false;
  }
  //
  // Future<Map<String, String>> _uplaodImageToServer(List<int> imageData) async {
  //   final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   UploadTask task = FirebaseStorage.instance
  //       .ref()
  //       .child("ahmed_test" + '-' + fileName)
  //       .putData(imageData);
  //
  //   final taskSnapshot = await task.snapshot.storage;
  //   return {
  //     'url': await taskSnapshot.ref.getDownloadURL(),
  //     'fileName': fileName,
  //   };
  // }

  Future uploadFile() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats/${Path.basename(_image.path)}}');
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.whenComplete(() => null);
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  Widget chatMessages(TextDirection textDirection) {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        var width = MediaQuery
            .of(context)
            .size
            .width;
        return snapshot.hasData
            ? ListView.builder(
          padding: EdgeInsets.only(bottom: 70, top: 16),
          itemCount: snapshot.data.docs.length,
          reverse: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            ds.reference.parent.doc("sendBy").get().then((value) {
              if (userID != value.get("sendBy")) {
                FirebaseFirestore.instance
                    .collection("Courses")
                    .doc(widget.courseID)
                    .collection("chats")
                    .doc(widget.charRoomID)
                    .update({"read": true});
              }
              if (instructorID == value.get("sendBy") &&
                  userID != instructorID) {
                FirebaseFirestore.instance
                    .collection("Courses")
                    .doc(widget.courseID)
                    .update({
                  "notification": FieldValue.arrayRemove([userID])
                });
              } else if (instructorID != value.get("sendBy") &&
                  userID == instructorID) {
                FirebaseFirestore.instance
                    .collection("Courses")
                    .doc(widget.courseID)
                    .update({
                  "new_messages":
                  FieldValue.arrayRemove([widget.student]),
                });
              }
            });

            if (userID != ds["sendBy"]) {
              if (ds["read"] == false) {
                readAllNewMessages(widget.courseID, widget.charRoomID,
                    userID, ds.reference.id);
              }
            }
            DateTime d = ds["ts"].toDate();
            if (index == snapshot.data.docs.length - 1) {
              DateTime d = ds["ts"].toDate();

              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    color: Theme
                        .of(context)
                        .backgroundColor,
                    child: Text(
                      "${intl.DateFormat("yMMMMd").format(d).toString()}",
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade400),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  chatMessageTile(ds["message"], userID == ds["sendBy"],
                      textDirection, width, ds["ts"], ds["read"])
                ],
              );
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
    instructorID = await FirebaseUtilities.getInstructorID();
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
    messageController = TextEditingController();
    super.initState();
  }

  void _clear() {
    messageController.clear();
    setState(() {});
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
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        brightness: Theme
            .of(context)
            .appBarTheme
            .brightness,
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
        iconTheme: Theme
            .of(context)
            .appBarTheme
            .iconTheme,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(16,
                      color: Theme
                          .of(context)
                          .textTheme
                          .caption
                          .color,
                      fontWeight: FontWeight.w600)
                      : Utilities.getTajwalTextStyleWithSize(16,
                      color: Theme
                          .of(context)
                          .textTheme
                          .caption
                          .color,
                      fontWeight: FontWeight.w600),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(widget.otherSideUserID)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    DocumentSnapshot ds = snapshot.data;

                    if (snapshot.data == null) return SizedBox();
                    DateTime d;
                    String day;
                    if (ds.get("status") != "online") {
                      var t = ds.get("last_seen");
                      d = t.toDate();

                      int days = DateTime(d.year, d.month, d.day)
                          .difference(DateTime(DateTime
                          .now()
                          .year,
                          DateTime
                              .now()
                              .month, DateTime
                              .now()
                              .day))
                          .inDays;

                      if (days == 0) {
                        day = "today";
                      } else if (days < 0) {
                        days < -1
                            ? day =
                            intl.DateFormat('d MMM').format(d).toString()
                            : day = "yesterday";
                      }
                    }
                    return ds.get("status") == "online"
                        ? Text(
                      ds.get("status"),
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                          fontWeight: FontWeight.w400),
                    )
                        : Text(
                      "last seen $day at ${intl.DateFormat("hh:mm a")
                          .format(d)
                          .toString()}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                      textDirection: TextDirection.ltr,
                    );
                  },
                )
              ],
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
                color: Theme
                    .of(context)
                    .scaffoldBackgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    // Icon(
                    //   Icons.add,
                    //   // size: 15,
                    // ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        // margin: EdgeInsets.only(bottom: 30.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Theme
                              .of(context)
                              .backgroundColor,
                        ),
                        child: TextField(
                          controller: messageController,
                          minLines: 1,
                          maxLines: null,
                          // onChanged: widget.onChange,
                          decoration: InputDecoration(
                              border: InputBorder.none, isDense: true
                            // icon: widget.icon != null ? Icon(widget.icon) : null),
                          ),
                          onChanged: (x) {
                            print(messageController.text);

                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: messageController.text.length == 0,
                      replacement: Row(
                        children: [
                          SizedBox(
                            width: 7.5,
                          ),
                          InkWell(
                            child: Icon(
                              Icons.send,
                              color: Colors.green.shade900,
                              size: 24,
                            ),
                            onTap: () {
                              addMessage(
                                true,
                                userID,
                              );
                            },
                          ),
                          SizedBox(
                            width: 7.5,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 7.5,
                          ),
                          Icon(
                            Icons.send,
                            color: Colors.green.shade100,
                            size: 24,
                          ),
                          SizedBox(
                            width: 7.5,
                          ),
                        ],
                      ),
                      // child: Row(
                      //   children: [
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     GestureDetector(
                      //       child: Icon(Icons.photo_camera),
                      //         onTap: () => chooseFile(),
                      //     ),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Icon(
                      //       Icons.mic,
                      //     ),
                      //   ],
                      // ),
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
