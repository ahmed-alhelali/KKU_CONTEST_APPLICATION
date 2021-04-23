import 'package:kku_contest_app/imports.dart';

class InstructorDrawerScreen extends StatefulWidget {
  final AnimationController controller;
  final TextDirection textDirection;
  final String userName;
  final String userURLImage;
  final String uid;



  const InstructorDrawerScreen({Key key, this.controller, this.textDirection,this.userName,this.userURLImage,this.uid})
      : super(key: key);

  @override
  _InstructorDrawerScreenState createState() => _InstructorDrawerScreenState();
}

class _InstructorDrawerScreenState extends DrawerStateMaster<InstructorDrawerScreen> {

  AnimationController get controller => widget.controller;

  String get currierKey => "instructor";

  String get nameKey => widget.userName;

  String get imagePath => widget.userURLImage;

  Widget get courses =>
      InstructorWidgets.getInstructorCoursesInDrawer(widget.textDirection,widget.uid);

  String get warringKey => "instructor_logout_warning";
}
