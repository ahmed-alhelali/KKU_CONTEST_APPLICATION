import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kku_contest_app/localization/my_localization.dart';
import 'package:kku_contest_app/models/app_theme.dart';
import 'package:kku_contest_app/models/languages.dart';
import 'package:kku_contest_app/screens/student/student_wrapper_screen.dart';
import 'package:kku_contest_app/utilities/utilities.dart';
import 'package:provider/provider.dart';
import 'instructor/instructor_wrapper_screen.dart';

class WrapperScreen extends StatefulWidget {
  @override
  _WrapperScreenState createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.isDarkMode ? false : true;

    return Scaffold(
      backgroundColor: isLightTheme ? AppTheme.lightTheme.scaffoldBackgroundColor : AppTheme.darkTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isLightTheme ? AppTheme.lightTheme.backgroundColor : AppTheme.darkTheme.backgroundColor,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 12,
                right: 15,
                child: TextButton(
                  onPressed: () {
                    textDirection == TextDirection.ltr
                        ? Utilities.changeLanguages(
                      Languages(1, 'عربي', 'ar'),
                      context,
                    )
                        : Utilities.changeLanguages(
                      Languages(0, 'English', 'en'),
                      context,
                    );
                  },
                  child: Text(
                    MyLocalization.of(context)
                        .getTranslatedValue("change_language"),
                    style:
                    GoogleFonts.ubuntu(fontSize: 16, color: isLightTheme ? Colors.black : Colors.white),
                  ),
                ),
              ),
              isLightTheme ? Center() : Column(
                children: [
                  SizedBox(
                    height: 120,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: Image(
                      image: ExactAssetImage("assets/images/icons.png"),
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      MyLocalization.of(context)
                          .getTranslatedValue("sign_in_page_title"),
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(24,
                          fontWeight: FontWeight.bold,color: themeProvider.themeColor(isLightTheme).textColor)
                          : Utilities.getTajwalTextStyleWithSize(24,
                          fontWeight: FontWeight.bold,color: themeProvider.themeColor(isLightTheme).textColor),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      MyLocalization.of(context)
                          .getTranslatedValue("sign_in_page_subTitle"),
                      style: textDirection == TextDirection.ltr
                          ? Utilities.getUbuntuTextStyleWithSize(14,color: themeProvider.themeColor(isLightTheme).textColor)
                          : Utilities.getTajwalTextStyleWithSize(14,color: themeProvider.themeColor(isLightTheme).textColor),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 200,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 120,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.grey,
                          elevation: 0,
                          backgroundColor: isLightTheme ? AppTheme.lightTheme.scaffoldBackgroundColor : AppTheme.darkTheme.scaffoldBackgroundColor,

                        ),
                        child: Text(
                          MyLocalization.of(context)
                              .getTranslatedValue("instructor"),
                          style: textDirection == TextDirection.ltr
                              ? Utilities.getUbuntuTextStyleWithSize(14,color: themeProvider.themeColor(isLightTheme).textColor)
                              : Utilities.getTajwalTextStyleWithSize(12,color: themeProvider.themeColor(isLightTheme).textColor),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InstructorWrapperScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.grey,
                          elevation: 0,
                          backgroundColor: isLightTheme ? AppTheme.lightTheme.scaffoldBackgroundColor : AppTheme.darkTheme.scaffoldBackgroundColor,

                        ),
                        child: Text(
                          MyLocalization.of(context)
                              .getTranslatedValue("student"),
                          style: textDirection == TextDirection.ltr
                              ? Utilities.getUbuntuTextStyleWithSize(14,color: themeProvider.themeColor(isLightTheme).textColor)
                              : Utilities.getTajwalTextStyleWithSize(12,color: themeProvider.themeColor(isLightTheme).textColor),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentWrapperScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}