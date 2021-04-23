import 'package:kku_contest_app/imports.dart';

class InstructorCourse extends StatefulWidget {
  final String courseTitle;
  final String id;
  final String uid;


  InstructorCourse({this.courseTitle, this.id, this.uid});

  @override
  _InstructorCourseState createState() => _InstructorCourseState();
}

class _InstructorCourseState extends State<InstructorCourse>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          brightness: Theme.of(context).appBarTheme.brightness,
          backgroundColor: Colors.transparent,
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          title: Text(
            widget.courseTitle,
            style: textDirection == TextDirection.ltr
                ? Utilities.getUbuntuTextStyleWithSize(
                    16,
                    color: Theme.of(context).textTheme.caption.color,
                  )
                : Utilities.getTajwalTextStyleWithSize(
                    16,
                    color: Theme.of(context).textTheme.caption.color,
                  ),
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).backgroundColor,
            ),
            tabs: [
              Tab(
                child: InstructorWidgets.getChildForTab(
                    context, "lecture_section", textDirection),
              ),
              Tab(
                child: InstructorWidgets.getChildForTab(
                    context, "student_section", textDirection),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            InstructorLecturesScreen(
              id: widget.id,
              uid: widget.uid,
            ),
            HelpStudentScreen(
              id: widget.id,
            ),
          ],
        ),
      ),
    );
  }
}
