import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kku_contest_app/utilities/utilities.dart';

class FirestoreDB {

  static addCourse(String courseTitle) {
    CollectionReference newCourse =
        FirebaseFirestore.instance.collection("Courses");

    return newCourse
        .doc(Utilities.getRandomIdForNewCourse())
        .set({"course_title": courseTitle, "time": DateTime.now()})
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
              // print("1 value  ${element.data().values.first}");
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
}