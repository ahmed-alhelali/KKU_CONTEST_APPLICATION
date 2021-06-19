import 'package:kku_contest_app/imports.dart';

class InstructorHomeScreen extends StatefulWidget {
  final AnimationController controller;
  final Duration duration;
  final TextDirection textDirection;
  final String uid;

  const InstructorHomeScreen(
      {Key key, this.controller, this.duration, this.textDirection, this.uid})
      : super(key: key);

  @override
  _InstructorHomeScreenState createState() => _InstructorHomeScreenState();
}

class _InstructorHomeScreenState
    extends HomeScreenStateMaster<InstructorHomeScreen> {
  final lectureTitleController = TextEditingController();

  String userName;
  String userImageUrl;
  String userID;

  getUserInfo() async {
    userName = await FirebaseUtilities.getUserName();
    userImageUrl = await FirebaseUtilities.getUserImageUrl();
    userID = await FirebaseUtilities.getUserId();
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  @override
  void dispose() {
    lectureTitleController.dispose();
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
          centerTitle: true,
          elevation: 0,
          brightness: Theme.of(context).appBarTheme.brightness,
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          backgroundColor: Colors.transparent,
        ),
        body: InstructorWidgets.getInstructorCourses(
            widget.textDirection, widget.uid),
        floatingActionButton: Padding(
          padding: EdgeInsets.all(6),
          child: FloatingActionButton(
            onPressed: () {
              InstructorWidgets.addCourseWidget(widget.textDirection, context,
                  lectureTitleController, userID,userImageUrl,userName);
              // print(name);
              // print(id);
              // print(imageUrl);

            },
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 45,
            ),
          ),
        ),


      );
}
