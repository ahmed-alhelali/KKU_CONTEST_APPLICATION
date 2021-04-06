import 'package:kku_contest_app/imports.dart';

class StudentHomeScreen extends StatefulWidget {
  final AnimationController controller;
  final Duration duration;

  const StudentHomeScreen({Key key, this.controller, this.duration})
      : super(key: key);

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  bool menuOpen = false;
  Animation<double> _scaleAnimation;

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final searchController = TextEditingController();
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
                          FocusScope.of(context).requestFocus(FocusNode());
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
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    if (searchController.text != "") {
                      final courseX = await FirebaseFirestore.instance
                          .collection("Courses")
                          .doc(searchController.text)
                          .get();
                      if (courseX.exists) {
                        await FirebaseFirestore.instance
                            .collection("Courses")
                            .doc(searchController.text)
                            .update({"access_by_student": true});
                      } else {
                        Toast.show(
                          MyLocalization.of(context)
                              .getTranslatedValue("course_not_exist"),
                          context,
                          duration: Toast.LENGTH_LONG,
                          gravity: Toast.CENTER,
                        );
                      }
                      searchController.text = "";
                    } else {
                      print("ignore the click");
                    }
                  },
                  color: Theme.of(context).appBarTheme.iconTheme.color,
                ),
              ],
              centerTitle: true,
              elevation: 0,
              brightness: Theme.of(context).appBarTheme.brightness,
              backgroundColor: Colors.transparent,
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: searchController,
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(
                              16,
                              color: Theme.of(context).textTheme.caption.color,
                            )
                          : Utilities.getTajwalTextStyleWithSize(
                              16,
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                          borderSide: BorderSide(
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                          borderSide: BorderSide(
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                        hintText: MyLocalization.of(context)
                            .getTranslatedValue("search"),
                        hintStyle: textDirection == TextDirection.ltr
                            ? Utilities.getUbuntuTextStyleWithSize(14,
                                color: Colors.grey)
                            : Utilities.getTajwalTextStyleWithSize(14,
                                color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: StudentWidgets.getStudentCourses(textDirection)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
