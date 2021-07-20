import 'package:connected/controllers/theme_controllers/theme_controller.dart';

import '../imports.dart';

abstract class DrawerStateMaster<T extends StatefulWidget> extends State<T> {
  String currierKey;
  String nameKey;
  String imagePath;
  Widget courses;

  String warringKey;

  AnimationController controller;
  Animation<double> _scaleAnimation;
  Animation<Offset> _slideAnimation;

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    Authentication authentication = Provider.of<Authentication>(context, listen: false);

    if (_scaleAnimation == null) {
      _scaleAnimation = Tween<double>(begin: 0.6, end: 1).animate(controller);
    }
    if (_slideAnimation == null) {
      _slideAnimation = textDirection == TextDirection.ltr
          ? Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
              .animate(controller)
          : Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
              .animate(controller);
    }
    return Consumer(builder: (context, ThemeController themeNotifier, child){
      return SlideTransition(
        position: _slideAnimation,
        textDirection: textDirection,
        child: ScaleTransition(
          scale: _scaleAnimation,
          alignment: Alignment.topRight,
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: ListView(
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
                                .getTranslatedValue(currierKey)
                                .toUpperCase(),
                            style: textDirection == TextDirection.ltr
                                ? Utilities.getUbuntuTextStyleWithSize(
                              18,
                              color:
                              Theme.of(context).textTheme.caption.color,
                              fontWeight: FontWeight.bold,
                            )
                                : Utilities.getTajwalTextStyleWithSize(
                              18,
                              color:
                              Theme.of(context).textTheme.caption.color,
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
                          themeNotifier.isDark
                              ? FontAwesomeIcons.lightbulb
                              : FontAwesomeIcons.solidLightbulb,
                          color: Theme.of(context).appBarTheme.iconTheme.color,
                        ),
                        onPressed: () async {
                          themeNotifier.isDark
                              ? themeNotifier.isDark = false
                              : themeNotifier.isDark = true;
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
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 110.00,
                              height: 110.00,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(1),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 100.00,
                              height: 100.00,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                            ),
                            CircleAvatar(
                              radius: 45,
                              backgroundImage: NetworkImage(imagePath),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          nameKey,
                          style: textDirection == TextDirection.ltr
                              ? Utilities.getUbuntuTextStyleWithSize(
                            18,
                            color:
                            Theme.of(context).textTheme.caption.color,
                          )
                              : Utilities.getTajwalTextStyleWithSize(
                            18,
                            color:
                            Theme.of(context).textTheme.caption.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 25),
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
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: courses,
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
                      warringKey,
                      context,
                      "logout",
                      "cancel",
                      textDirection,
                      functionOfYesButton: () async {
                        authentication.signOut();

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
      );
    });
  }
}
