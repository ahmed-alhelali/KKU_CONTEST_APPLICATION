import 'package:kku_contest_app/imports.dart';

class InstructorCourse extends StatefulWidget {
  final String courseTitle;
  final String id;

  InstructorCourse({this.courseTitle, this.id});

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.isDarkMode ? false : true;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isLightTheme
            ? AppTheme.lightTheme.scaffoldBackgroundColor
            : AppTheme.darkTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          brightness: isLightTheme
              ? AppTheme.lightTheme.appBarTheme.brightness
              : AppTheme.darkTheme.appBarTheme.brightness,
          backgroundColor: Colors.transparent,
          iconTheme: isLightTheme
              ? AppTheme.lightTheme.appBarTheme.iconTheme
              : AppTheme.darkTheme.appBarTheme.iconTheme,
          title: Text(
            widget.courseTitle,
            style: textDirection == TextDirection.ltr
                ? Utilities.getUbuntuTextStyleWithSize(16,
                    color: themeProvider.themeColor(isLightTheme).textColor)
                : Utilities.getTajwalTextStyleWithSize(16,
                    color: themeProvider.themeColor(isLightTheme).textColor),
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: isLightTheme
                  ? AppTheme.lightTheme.backgroundColor
                  : AppTheme.darkTheme.backgroundColor,
            ),
            tabs: [
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: Colors.redAccent, width: 1)
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      MyLocalization.of(context)
                          .getTranslatedValue("lecture_section"),
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(12,
                              color: themeProvider
                                  .themeColor(isLightTheme)
                                  .textColor)
                          : Utilities.getTajwalTextStyleWithSize(12,
                              color: themeProvider
                                  .themeColor(isLightTheme)
                                  .textColor),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: Colors.redAccent, width: 1),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      MyLocalization.of(context)
                          .getTranslatedValue("student_section"),
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(12,
                              color: themeProvider
                                  .themeColor(isLightTheme)
                                  .textColor)
                          : Utilities.getTajwalTextStyleWithSize(12,
                              color: themeProvider
                                  .themeColor(isLightTheme)
                                  .textColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            InstructorLecturesScreen(
              id: widget.id,
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
