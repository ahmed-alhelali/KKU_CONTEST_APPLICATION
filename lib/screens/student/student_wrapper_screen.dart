import 'package:kku_contest_app/imports.dart';

class StudentWrapperScreen extends StatefulWidget {
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
          ),
          StudentHomeScreen(
            controller: _controller,
            duration: duration,
            textDirection: textDirection,
          )
        ],
      ),
    );
  }
}
