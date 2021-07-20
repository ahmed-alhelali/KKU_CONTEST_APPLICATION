import 'package:connected/imports.dart';

class InstructorWrapperScreen extends StatefulWidget {
  final String userName;
  final String userURLImage;
  final String userID;

  const InstructorWrapperScreen({Key key, this.userName, this.userURLImage,this.userID}) : super(key: key);

  @override
  _InstructorWrapperScreenState createState() =>
      _InstructorWrapperScreenState();
}

class _InstructorWrapperScreenState extends State<InstructorWrapperScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final Duration duration = Duration(milliseconds: 300);

  @override
  void initState() {
    _controller = AnimationController(duration: duration, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          InstructorDrawerScreen(
            controller: _controller,
            textDirection: textDirection,
            userURLImage: widget.userURLImage,
            userName: widget.userName,
            uid: widget.userID,
          ),
          InstructorHomeScreen(
            controller: _controller,
            duration: duration,
            textDirection: textDirection,
            uid: widget.userID,
          )
        ],
      ),
    );
  }
}
