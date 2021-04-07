import 'imports.dart';

abstract class HomeScreenStateMaster<T extends StatefulWidget> extends State<T> {

  Widget child;
  AnimationController controller;
  Duration duration;


  bool menuOpen = false;
  Animation<double> _scaleAnimation;



  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    if (_scaleAnimation == null) {
      _scaleAnimation =
          Tween<double>(begin: 1, end: 0.6).animate(controller);
    }
    var size = MediaQuery.of(context).size;
    return AnimatedPositioned(
      curve: Curves.fastOutSlowIn,
      duration: duration,
      top: 0,
      bottom: 0,
      left: menuOpen
          ? (textDirection == TextDirection.ltr
          ? 0.3 * size.width
          : -0.35 * size.width)
          : 0,
      right: menuOpen
          ? (textDirection == TextDirection.ltr
          ? -0.35 * size.width
          : 0.3 * size.width)
          : 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ClipRRect(
          borderRadius:
          menuOpen ? BorderRadius.circular(30) : BorderRadius.circular(0),
          child: child,
        ),
      ),
    );
  }
}