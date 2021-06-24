import 'package:kku_contest_app/imports.dart';

class FirestoreDB {
  static saveUserToFirebase(String name, String id, String status) async {
    final snapShot = await FirebaseFirestore.instance.collection("Users").doc(id).get();

    if (snapShot.exists) {
      FirebaseFirestore.instance.collection("Users").doc(id).update({
        "status": status,
      });
    } else {
      FirebaseFirestore.instance.collection("Users").doc(id).set({
        "name": name,
        "id": id,
        "status": status,
        "last_seen": DateTime.now()
      });
    }
  }

  static addCourse(
      String courseTitle, String uid, String userImage, String userName) {
    CollectionReference newCourse =
        FirebaseFirestore.instance.collection("Courses");

    return newCourse
        .doc(Utilities.getRandomIdForNewCourse())
        .set({
          "access_by_students": [],
          "time": DateTime.now(),
          "course_title": courseTitle,
          "uid": uid,
          "name": userName,
          "notification": [],
          "new_messages": [],
          "imageUrl": userImage,
        })
        .then((value) => {print("course added")})
        .catchError((error) => print(error));
  }

  static deleteCourse(courseID) {
    CollectionReference courses =
        FirebaseFirestore.instance.collection("Courses");

    return courses
        .doc(courseID)
        .delete()
        .then((value) => {
              print("Course deleted"),
              deleteAllLecturesUnderCourseDeleted(courseID)
            })
        .catchError((error) => print(error));
  }

  static deleteAllLecturesUnderCourseDeleted(courseID) async {
    CollectionReference courses =
        FirebaseFirestore.instance.collection("Courses");

    final lectures = courses.doc(courseID).collection("lectures").get();
    return await lectures
        .then((lecture) => lecture.docs.forEach((element) {
              deleteAllStepsUnderLecture(courseID, element.data().values.first);
              deleteLecture(courseID, element.data().values.first);
            }))
        .catchError((error) => print(error));
  }

  static deleteAllStepsUnderLecture(
      String courseID, String lectureTitle) async {
    CollectionReference courses = FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
        .collection("lectures");

    final steps = courses.doc(lectureTitle).collection("steps").get();
    return await steps
        .then((step) => step.docs.forEach((element) {
              element.reference.delete();
            }))
        .then((value) => {print("all steps deleted")})
        .catchError((error) => print(error));
  }

  static deleteLecture(courseID, lectureTitle) {
    CollectionReference courses =
        FirebaseFirestore.instance.collection("Courses");

    final lecture =
        courses.doc(courseID).collection("lectures").doc(lectureTitle);

    return lecture.delete();
  }

  static Future addMessage(String courseID, String chatRoomID, String messageId,
      Map messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
        .collection("chats")
        .doc(chatRoomID)
        .collection("my_chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  static updateLastMessageSend(
      String courseID, String chatRoomId, Map lastMessageInfoMap,
      {sendBy}) {
    FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
        .collection("chats")
        .doc(chatRoomId)
        .collection("my_chats")
        .doc("sendBy")
        .update({"sendBy": sendBy});

    return FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
        .collection("chats")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  static createChatRoom(
      String courseID, String chatRoomID, Map chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
        .collection("chats")
        .doc(chatRoomID)
        .get();

    if (snapShot.exists) {
      //when the chatRoom exist we don't need to create it
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("Courses")
          .doc(courseID)
          .collection("chats")
          .doc(chatRoomID)
          .set(chatRoomInfoMap);
    }
  }

  static Future<Stream<QuerySnapshot>> getChatRoomMessages(
      courseID, String chatRoomID) async {
    print("THE CHAT ROOM IS THIS $chatRoomID");
    return FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
        .collection("chats")
        .doc(chatRoomID)
        .collection("my_chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  static Future<Stream<QuerySnapshot>> getChatRooms(courseID) async {
    return FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseID)
        .collection("chats")
        .snapshots();
  }
}
