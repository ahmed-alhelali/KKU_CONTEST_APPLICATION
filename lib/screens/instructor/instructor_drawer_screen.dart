import 'package:kku_contest_app/imports.dart';

class InstructorDrawerScreen extends StatefulWidget {
  final AnimationController controller;
  final TextDirection textDirection;

  const InstructorDrawerScreen({Key key, this.controller, this.textDirection})
      : super(key: key);

  @override
  _InstructorDrawerScreenState createState() => _InstructorDrawerScreenState();
}

class _InstructorDrawerScreenState
    extends DrawerStateMaster<InstructorDrawerScreen> {
  AnimationController get controller => widget.controller;

  String get currierKey => "instructor";

  String get nameKey => "instructor_name";

  String get imagePath => "assets/images/instructor_avatar.jpg";

  Widget get courses =>
      InstructorWidgets.getInstructorCoursesInDrawer(widget.textDirection);

  String get warringKey => "instructor_logout_warning";
}
