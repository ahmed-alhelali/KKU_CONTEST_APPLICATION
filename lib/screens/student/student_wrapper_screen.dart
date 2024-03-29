import 'package:connected/imports.dart';

class StudentWrapperScreen extends StatefulWidget {
  final String userName;
  final String userURLImage;
 final String uid;

  const StudentWrapperScreen({Key key, this.userName, this.userURLImage,this.uid}) : super(key: key);

  @override
  _StudentWrapperScreenState createState() => _StudentWrapperScreenState();
}

class _StudentWrapperScreenState extends State<StudentWrapperScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final Duration duration = Duration(milliseconds: 300);

  @override
  void initState() {
    _controller = AnimationController(duration: duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          StudentDrawerScreen(
            controller: _controller,
            textDirection: textDirection,
            userName: widget.userName,
            userURLImage: widget.userURLImage,
            uid: widget.uid,

          ),
          StudentHomeScreen(
            controller: _controller,
            duration: duration,
            textDirection: textDirection,
            uid: widget.uid,
          )
        ],
      ),
    );
  }
}
