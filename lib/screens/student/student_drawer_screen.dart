import 'package:kku_contest_app/imports.dart';

class StudentDrawerScreen extends StatefulWidget {
  final AnimationController controller;

  const StudentDrawerScreen({Key key, this.controller}) : super(key: key);

  @override
  _StudentDrawerScreenState createState() => _StudentDrawerScreenState();
}

class _StudentDrawerScreenState extends State<StudentDrawerScreen> {
  Animation<double> _scaleAnimation;
  Animation<Offset> _slideAnimation;

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.isDarkMode ? false : true;

    if (_scaleAnimation == null) {
      _scaleAnimation =
          Tween<double>(begin: 0.6, end: 1).animate(widget.controller);
    }
    if (_slideAnimation == null) {
      _slideAnimation = textDirection == TextDirection.ltr
          ? Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
              .animate(widget.controller)
          : Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
              .animate(widget.controller);
    }
    return SlideTransition(
      position: _slideAnimation,
      textDirection: textDirection,
      child: ScaleTransition(
        scale: _scaleAnimation,
        alignment: Alignment.topRight,
        child: Scaffold(
          body: Container(
            color: Theme.of(context).backgroundColor,

            child: ListView(
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: textDirection == TextDirection.ltr
                              ? BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                )
                              : BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Center(
                          child: Text(
                            MyLocalization.of(context)
                                .getTranslatedValue("student")
                                .toUpperCase(),
                            style: textDirection == TextDirection.ltr
                                ? Utilities.getUbuntuTextStyleWithSize(
                                    18,
                                    color: Theme.of(context).textTheme.caption.color,
                                    fontWeight: FontWeight.bold,
                                  )
                                : Utilities.getTajwalTextStyleWithSize(
                                    18,
                                    color: Theme.of(context).textTheme.caption.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: IconButton(
                        icon: Icon(
                          isLightTheme
                              ? FontAwesomeIcons.lightbulb
                              : FontAwesomeIcons.solidLightbulb,
                          color: Theme.of(context).appBarTheme.iconTheme.color,
                        ),
                        onPressed: () {
                          final provider = Provider.of<ThemeProvider>(context,
                              listen: false);
                          provider.changeAppTheme(isLightTheme);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 110.00,
                              height: 110.00,
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor
                                        .withOpacity(1),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 100.00,
                              height: 100.00,
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                            ),
                            CircleAvatar(
                              radius: 45,
                              backgroundImage:
                                  ExactAssetImage("assets/images/student.png"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          MyLocalization.of(context)
                              .getTranslatedValue("student_name"),
                          style: textDirection == TextDirection.ltr
                              ? Utilities.getUbuntuTextStyleWithSize(16,
                                  color: Theme.of(context).textTheme.caption.color,)
                              : Utilities.getTajwalTextStyleWithSize(14,
                                  color: Theme.of(context).textTheme.caption.color,),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Widgets.getContainerWithOnOnTap(
                  Icon(
                    Icons.my_library_books_outlined,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  "my_courses",
                  textDirection,
                  context,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.5,
                  //color: Colors.grey,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: StudentWidgets.getStudentCoursesInDrawer( textDirection),
                ),
                Widgets.getContainerWithOnOnTap(
                  Icon(
                    FontAwesomeIcons.language,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  "app_language",
                  textDirection,
                  context,
                  onTap: () {
                    Widgets.changeLanguageWidget(textDirection, context);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Widgets.getContainerWithOnOnTap(
                  Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  "logout",
                  textDirection,
                  context,
                  onTap: () {
                    Widgets.showWarringDialog(
                      "are_you_sure",
                      "student_logout_warning",
                      context,
                      "logout",
                      "cancel",
                      textDirection,
                      functionOfYesButton: () {
                        FirestoreDB.signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WrapperScreen(),
                          ),
                        );
                      },
                      functionOfNoButton: () {
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
