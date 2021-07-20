import 'package:connected/imports.dart';

class Widgets {
  static changeLanguageWidget(
      TextDirection textDirection, BuildContext context) {
    showModalBottomSheet(
      context: context,
      elevation: 10,
      barrierColor: Theme.of(context).shadowColor,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              textDirection == TextDirection.ltr
                  ? Positioned(
                      right: 40,
                      bottom: MediaQuery.of(context).size.height * 0.2,
                      child: Icon(
                        FontAwesomeIcons.language,
                        color: Theme.of(context).textTheme.caption.color,
                        size: 35,
                      ),
                    )
                  : Positioned(
                      left: 40,
                      bottom: MediaQuery.of(context).size.height * 0.2,
                      child: Icon(
                        FontAwesomeIcons.language,
                        color: Theme.of(context).textTheme.caption.color,
                        size: 35,
                      ),
                    ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: 150,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).textTheme.caption.color,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    Text(
                      MyLocalization.of(context)
                          .getTranslatedValue("app_language")
                          .toUpperCase(),
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(
                              16,
                              letterSpacing: 1,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.caption.color,
                            )
                          : Utilities.getTajwalTextStyleWithSize(
                              16,
                              letterSpacing: 1,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 3),
                            child: SizedBox(
                              width: 90,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.grey,
                                  elevation: 0,
                                  backgroundColor:
                                      textDirection == TextDirection.ltr
                                          ? Theme.of(context).backgroundColor
                                          : Colors.transparent,
                                ),
                                child: Text(
                                  'English',
                                  style: textDirection == TextDirection.ltr
                                      ? Utilities.getUbuntuTextStyleWithSize(
                                          16,
                                          letterSpacing: 1,
                                          height: 1.2,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        )
                                      : Utilities.getTajwalTextStyleWithSize(
                                          16,
                                          letterSpacing: 1,
                                          height: 1.2,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        ),
                                ),
                                onPressed: () {
                                  Utilities.changeLanguages(
                                    Languages(0, 'English', 'en'),
                                    context,
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 3),
                            child: SizedBox(
                              width: 90,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.grey,
                                  elevation: 0,
                                  backgroundColor:
                                      textDirection == TextDirection.ltr
                                          ? Colors.transparent
                                          : Theme.of(context).backgroundColor,
                                ),
                                child: Text(
                                  'عربي',
                                  style: textDirection == TextDirection.ltr
                                      ? Utilities.getUbuntuTextStyleWithSize(
                                          16,
                                          letterSpacing: 1,
                                          height: 1.2,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        )
                                      : Utilities.getTajwalTextStyleWithSize(
                                          16,
                                          letterSpacing: 1,
                                          height: 1.2,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color,
                                        ),
                                ),
                                onPressed: () {
                                  Utilities.changeLanguages(
                                    Languages(1, 'عربي', 'ar'),
                                    context,
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
        );
      },
    );
  }

  static Widget getContainerWithOnOnTap(Icon icon, String keyMap,
      TextDirection textDirection, BuildContext context,
      {Function onTap}) {
    return Padding(
      padding: textDirection == TextDirection.ltr
          ? EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.60,
            )
          : EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.60,
            ),
      child: InkWell(
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
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
            width: 150,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  icon,
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    MyLocalization.of(context).getTranslatedValue(keyMap),
                    style: textDirection == TextDirection.ltr
                        ? Utilities.getUbuntuTextStyleWithSize(
                            13,
                            color: Theme.of(context).textTheme.caption.color,
                          )
                        : Utilities.getTajwalTextStyleWithSize(
                            13,
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  static showWarringDialog(
    String keyTitle,
    String keyContent,
    BuildContext context,
    String yetText,
    String noText,
    TextDirection textDirection, {
    Function functionOfYesButton,
    Function functionOfNoButton,
  }) {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        MyLocalization.of(context).getTranslatedValue(keyTitle),
        style: textDirection == TextDirection.ltr
            ? Utilities.getUbuntuTextStyleWithSize(
                20,
                color: Theme.of(context).textTheme.caption.color,
              )
            : Utilities.getTajwalTextStyleWithSize(
                20,
                color: Theme.of(context).textTheme.caption.color,
              ),
      ),
      content: Text(
        MyLocalization.of(context).getTranslatedValue(keyContent),
        style: textDirection == TextDirection.ltr
            ? Utilities.getUbuntuTextStyleWithSize(14,
                color: Theme.of(context).textTheme.caption.color, height: 1.5)
            : Utilities.getTajwalTextStyleWithSize(
                14,
                color: Theme.of(context).textTheme.caption.color,
              ),
      ),
      actions: [
        functionOfNoButton == null
            ? Container()
            : TextButton(
                style: TextButton.styleFrom(
                  elevation: 0,
                  // backgroundColor: HexColor("#5C704D"),
                  backgroundColor: Colors.green.shade800,

                ),
                child: Text(
                  MyLocalization.of(context).getTranslatedValue(noText),
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(12)
                      : Utilities.getTajwalTextStyleWithSize(12),
                ),
                onPressed: functionOfNoButton,
              ),
        functionOfYesButton == null
            ? Container()
            : TextButton(
                style: TextButton.styleFrom(
                  elevation: 0,
                  // backgroundColor: HexColor("#A74552"),
                  backgroundColor: Colors.red.shade600,

                ),
                child: Text(
                  MyLocalization.of(context).getTranslatedValue(yetText),
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(12)
                      : Utilities.getTajwalTextStyleWithSize(12),
                ),
                onPressed: functionOfYesButton,
              ),
      ],
    );

    showDialog(
      context: context,
      barrierColor: Theme.of(context).shadowColor,
      builder: (context) => alertDialog,
    );
  }

  static getDialogToAskIfNeedMoreSteps(
    List titles,
    String keyTitle,
    BuildContext context,
    String yetText,
    String noText,
    TextDirection textDirection,
    Function functionOfYesButton,
    Function functionOfNoButton,
  ) {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        MyLocalization.of(context).getTranslatedValue(keyTitle),
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
      content: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: titles
                .map((e) => Column(
                      children: [
                        Text(
                          e,
                          style: textDirection == TextDirection.ltr
                              ? Utilities.getUbuntuTextStyleWithSize(
                                  12,
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                )
                              : Utilities.getTajwalTextStyleWithSize(
                                  12,
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ))
                .toList(),
          ),
        ),
      ),
      actions: [
        functionOfNoButton == null
            ? Container()
            : TextButton(
                style: TextButton.styleFrom(
                  elevation: 0,
                  // backgroundColor: HexColor("#5C704D"),
                  backgroundColor: Colors.green.shade800,

                ),
                child: Text(
                  MyLocalization.of(context).getTranslatedValue(noText),
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(12)
                      : Utilities.getTajwalTextStyleWithSize(12),
                ),
                onPressed: functionOfNoButton,
              ),
        functionOfYesButton == null
            ? Container()
            : TextButton(
                style: TextButton.styleFrom(
                  elevation: 0,
                  // backgroundColor: HexColor("#A74552"),
                  backgroundColor: Colors.red.shade600,

                ),
                child: Text(
                  MyLocalization.of(context).getTranslatedValue(yetText),
                  style: textDirection == TextDirection.ltr
                      ? Utilities.getUbuntuTextStyleWithSize(12)
                      : Utilities.getTajwalTextStyleWithSize(12),
                ),
                onPressed: functionOfYesButton,
              ),
      ],
    );

    showDialog(
      context: context,
      barrierColor: Theme.of(context).shadowColor,
      builder: (context) => alertDialog,
    );
  }
}
