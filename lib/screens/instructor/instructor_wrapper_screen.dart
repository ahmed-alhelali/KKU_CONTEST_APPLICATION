import 'package:kku_contest_app/imports.dart';

class InstructorWrapperScreen extends StatefulWidget {
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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          InstructorDrawerScreen(
            controller: _controller,
          ),
          InstructorHomeScreen(
            controller: _controller,
            duration: duration,
          )
        ],
      ),
    );
  }
}
