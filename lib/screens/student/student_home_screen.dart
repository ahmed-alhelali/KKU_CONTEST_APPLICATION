import 'dart:ui';

import 'package:connected/imports.dart';
import 'package:intl/intl.dart' as intl;

class StudentHomeScreen extends StatefulWidget {
  final AnimationController controller;
  final Duration duration;
  final TextDirection textDirection;
  final String uid;

  const StudentHomeScreen(
      {Key key, this.controller, this.duration, this.textDirection, this.uid})
      : super(key: key);

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends HomeScreenStateMaster<StudentHomeScreen> {
  TextEditingController searchController;

  Map<String, dynamic> courseMap;
  String courseID;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  AnimationController get controller => widget.controller;

  Duration get duration => widget.duration;

  Widget get child => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          leading: !menuOpen
              ? IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    print(courseID);
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
            MyLocalization.of(context).getTranslatedValue("home_page_title"),
            style: widget.textDirection == TextDirection.ltr
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
              icon: Icon(Icons.search),
              onPressed: onSearch,
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
                  style: widget.textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(
                          16,
                          color: Theme.of(context).textTheme.caption.color,
                        )
                      : Utilities.getTajwalTextStyleWithSize(
                          16,
                          color: Theme.of(context).textTheme.caption.color,
                        ),
                  decoration: InputDecoration(
                    isDense: true,
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
                    hintText:
                        MyLocalization.of(context).getTranslatedValue("search"),
                    hintStyle: widget.textDirection == TextDirection.ltr
                        ? Utilities.getUbuntuTextStyleWithSize(14,
                            color: Colors.grey)
                        : Utilities.getTajwalTextStyleWithSize(14,
                            color: Colors.grey),
                  ),
                  onChanged: (v) {
                    if (searchController.text == "") {
                      setState(() {
                        // isSearch = true;
                      });
                    }
                  },
                ),
              ),
            ),
            Flexible(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  StudentWidgets.getStudentCourses(
                      widget.textDirection, widget.uid),
                  courseMap != null
                      ? showAddCourseWidget(courseID)
                      : SizedBox(),
                ],
              ),
            )
          ],
        ),
      );

  void onSearch() async {
    if (searchController.text != "") {
      final courseX = await FirebaseFirestore.instance
          .collection("Courses")
          .doc(searchController.text)
          .get();
      if (courseX.exists) {
        await FirebaseFirestore.instance
            .collection("Courses")
            .doc(searchController.text)
            .get()
            .then((value) {
          setState(() {
            courseMap = value.data();
            courseID = value.reference.id;
          });
        });
      } else {
        Toast.show(
          MyLocalization.of(context).getTranslatedValue("course_not_exist"),
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );
      }
      _clear();
    }
  }

  void _clear() {
    searchController.clear();
    setState(() {});
  }

  showAddCourseWidget(courseID) {
    Timestamp t = courseMap['time'];
    DateTime d = t.toDate();
    return  BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).errorColor.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Theme.of(context).cardColor,
          // color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Course Name: ${courseMap["course_title"]}",
                      style: Utilities.getUbuntuTextStyleWithSize(14,
                          color: Theme.of(context).textTheme.caption.color,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text(
                      "Created By: ${courseMap["name"]}",
                      style: Utilities.getUbuntuTextStyleWithSize(
                        13,
                        color: Theme.of(context).textTheme.caption.color,
                      ),
                    ),
                    Text(
                      "date: ${intl.DateFormat("yMMMMd").format(d).toString()}",
                      style: Utilities.getUbuntuTextStyleWithSize(12,
                          color: Theme.of(context).textTheme.caption.color,
                          fontWeight: FontWeight.w100),
                    ),
                  ],
                )),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.green.shade800,
                        ),
                        child: Text(
                          "ADD",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("Courses")
                              .doc(courseID)
                              .update({
                            "access_by_students":
                            FieldValue.arrayUnion([widget.uid]),
                            "new_access": FieldValue.arrayUnion([widget.uid])
                          });
                          setState(() {
                            courseMap = null;
                            _clear();
                          });
                        },
                      ),
                      height: 30,
                      width: 50,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      child: TextButton(
                        child: Text(
                          "Undo",
                          style: TextStyle(
                              color: Theme.of(context).textTheme.caption.color),
                        ),
                        onPressed: () async {
                          setState(() {
                            courseMap = null;
                            _clear();
                          });
                        },
                      ),
                      height: 30,
                      width: 50,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );


  }
}
