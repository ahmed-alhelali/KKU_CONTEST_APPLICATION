import 'package:kku_contest_app/imports.dart';

class InstructorHomeScreen extends StatefulWidget {
  final AnimationController controller;
  final Duration duration;

  const InstructorHomeScreen({Key key, this.controller, this.duration})
      : super(key: key);

  @override
  _InstructorHomeScreenState createState() => _InstructorHomeScreenState();
}

class _InstructorHomeScreenState extends State<InstructorHomeScreen> {
  final lectureTitleController = TextEditingController();

  bool menuOpen = false;
  Animation<double> _scaleAnimation;

  @override
  void dispose() {
    lectureTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    if (_scaleAnimation == null) {
      _scaleAnimation =
          Tween<double>(begin: 1, end: 0.6).animate(widget.controller);
    }
    var size = MediaQuery.of(context).size;

    return AnimatedPositioned(
      curve: Curves.fastOutSlowIn,
      duration: widget.duration,
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
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              leading: !menuOpen
                  ? IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        setState(() {
                          widget.controller.forward();
                          menuOpen = true;
                        });
                      },
                      color: Theme.of(context).appBarTheme.iconTheme.color,
                    )
                  : IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        setState(() {
                          widget.controller.reverse();
                          menuOpen = false;
                        });
                      },
                      color: Theme.of(context).appBarTheme.iconTheme.color,
                    ),
              title: Text(
                MyLocalization.of(context)
                    .getTranslatedValue("home_page_title"),
                style: textDirection == TextDirection.ltr
                    ? Utilities.getUbuntuTextStyleWithSize(
                        14,
                        color: Theme.of(context).textTheme.caption.color,
                      )
                    : Utilities.getTajwalTextStyleWithSize(
                        14,
                        color: Theme.of(context).textTheme.caption.color,
                      ),
              ),
              centerTitle: true,
              elevation: 0,
              brightness: Theme.of(context).appBarTheme.brightness,
              // iconTheme: isLightTheme ? AppTheme.lightTheme.appBarTheme.iconTheme : AppTheme.darkTheme.appBarTheme.iconTheme,
              iconTheme: Theme.of(context).appBarTheme.iconTheme,
              backgroundColor: Colors.transparent,
            ),
            body: InstructorWidgets.getInstructorCourses(textDirection),
            floatingActionButton: Padding(
              padding: EdgeInsets.all(6),
              child: FloatingActionButton(
                onPressed: () {
                  InstructorWidgets.addCourseWidget(
                      textDirection, context, lectureTitleController);
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 45,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
