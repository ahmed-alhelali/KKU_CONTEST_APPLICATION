import 'package:kku_contest_app/imports.dart';

class StudentDrawerScreen extends StatefulWidget {
  final AnimationController controller;
  final TextDirection textDirection;

  const StudentDrawerScreen({Key key, this.controller, this.textDirection})
      : super(key: key);

  @override
  _StudentDrawerScreenState createState() => _StudentDrawerScreenState();
}

class _StudentDrawerScreenState extends DrawerStateMaster<StudentDrawerScreen> {
  AnimationController get controller => widget.controller;

  String get currierKey => "student";

  String get nameKey => "student_name";

  String get imagePath => "assets/images/student.png";

  Widget get courses =>
      StudentWidgets.getStudentCoursesInDrawer(widget.textDirection);

  String get warringKey => "student_logout_warning";
}
