import 'package:kku_contest_app/imports.dart';
class InstructorDrawerScreen extends StatefulWidget {
  final AnimationController controller;

  const InstructorDrawerScreen({Key key, this.controller}) : super(key: key);

  @override
  _InstructorDrawerScreenState createState() => _InstructorDrawerScreenState();
}

class _InstructorDrawerScreenState extends State<InstructorDrawerScreen> {
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
            color: isLightTheme
                ? AppTheme.lightTheme.backgroundColor
                : AppTheme.darkTheme.backgroundColor,
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
                          color: isLightTheme
                              ? AppTheme.lightTheme.scaffoldBackgroundColor
                              : AppTheme.darkTheme.scaffoldBackgroundColor,
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
                                .getTranslatedValue("instructor")
                                .toUpperCase(),
                            style: textDirection == TextDirection.ltr
                                ? Utilities.getUbuntuTextStyleWithSize(18,
                                    color: themeProvider
                                        .themeColor(isLightTheme)
                                        .textColor)
                                : Utilities.getTajwalTextStyleWithSize(18,
                                    color: themeProvider
                                        .themeColor(isLightTheme)
                                        .textColor),
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
                          color: isLightTheme ? Colors.black : Colors.white,
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
                                color: isLightTheme
                                    ? HexColor("#354251").withOpacity(0.2)
                                    : AppTheme
                                        .darkTheme.scaffoldBackgroundColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 100.00,
                              height: 100.00,
                              decoration: BoxDecoration(
                                color: isLightTheme
                                    ? HexColor("#354251").withOpacity(0.2)
                                    : Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                            CircleAvatar(
                              radius: 45,
                              backgroundImage: ExactAssetImage(
                                  "assets/images/instructor_avatar.jpg"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          MyLocalization.of(context)
                              .getTranslatedValue("instructor_name"),
                          style: textDirection == TextDirection.ltr
                              ? Utilities.getUbuntuTextStyleWithSize(16,
                                  color: themeProvider
                                      .themeColor(isLightTheme)
                                      .textColor)
                              : Utilities.getTajwalTextStyleWithSize(14,
                                  color: themeProvider
                                      .themeColor(isLightTheme)
                                      .textColor),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Widgets.getContainerWithOnOnTap(
                  themeProvider,
                  isLightTheme,
                  Icon(
                    Icons.my_library_books_outlined,
                    color: isLightTheme ? Colors.black : Colors.grey,
                  ),
                  "my_courses",
                  textDirection,
                  context,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: InstructorWidgets.getInstructorCoursesInDrawer(
                    themeProvider,
                    isLightTheme,
                    textDirection,
                  ),
                ),
                Widgets.getContainerWithOnOnTap(
                  themeProvider,
                  isLightTheme,
                  Icon(
                    FontAwesomeIcons.language,
                    color: isLightTheme ? Colors.black : Colors.grey,
                  ),
                  "app_language",
                  textDirection,
                  context,
                  onTap: () {
                    Widgets.changeLanguageWidget(
                        themeProvider, isLightTheme, textDirection, context);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Widgets.getContainerWithOnOnTap(
                  themeProvider,
                  isLightTheme,
                  Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  "logout",
                  textDirection,
                  context,
                  onTap: () {
                    Widgets.showWarringDialog(
                      themeProvider,
                      isLightTheme,
                      "are_you_sure",
                      "instructor_logout_warning",
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
