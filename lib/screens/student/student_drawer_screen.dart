import 'package:kku_contest_app/imports.dart';

class StudentDrawerScreen extends StatefulWidget {
  final AnimationController controller;
  final TextDirection textDirection;
  final String userName;
  final String userURLImage;
  final String uid;


  const StudentDrawerScreen(
      {Key key,
      this.controller,
      this.textDirection,
      this.userName,
      this.userURLImage,
      this.uid})
      : super(key: key);

  @override
  _StudentDrawerScreenState createState() => _StudentDrawerScreenState();
}

class _StudentDrawerScreenState extends DrawerStateMaster<StudentDrawerScreen> {
  AnimationController get controller => widget.controller;

  String get currierKey => "student";

  String get nameKey => widget.userName;

  String get imagePath => widget.userURLImage;

  Widget get courses =>
      StudentWidgets.getStudentCoursesInDrawer(widget.textDirection,widget.uid);

  String get warringKey => "student_logout_warning";
}
