import 'package:kku_contest_app/imports.dart';

class WrapperScreen extends StatefulWidget {
  @override
  _WrapperScreenState createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          margin: EdgeInsets.only(left: 12, right: 12, bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).backgroundColor,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 12,
                right: 15,
                child: TextButton(
                  onPressed: () {
                    print(FirebaseUtilities.getUserEmail());
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
                    style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 120,
                  ),
                  Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.chalkboardTeacher,
                        size: 80,
                        textDirection: TextDirection.ltr,
                        color: Theme.of(context).shadowColor,
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Transform.rotate(
                        angle: 45 * pi / 180,
                        child: Icon(
                          FontAwesomeIcons.link,
                          size: 50,
                          textDirection: TextDirection.ltr,
                          color: Colors.green.shade800,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        FontAwesomeIcons.users,
                        size: 80,
                        textDirection: TextDirection.ltr,
                        color: Theme.of(context).shadowColor,
                      ),
                    ],
                  ),
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
                          ? Utilities.getUbuntuTextStyleWithSize(
                              24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.caption.color,
                            )
                          : Utilities.getTajwalTextStyleWithSize(
                              24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      MyLocalization.of(context)
                          .getTranslatedValue("sign_in_page_subTitle"),
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
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Text(
                          MyLocalization.of(context)
                              .getTranslatedValue("instructor"),
                          style: textDirection == TextDirection.ltr
                              ? Utilities.getUbuntuTextStyleWithSize(
                                  14,
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                )
                              : Utilities.getTajwalTextStyleWithSize(
                                  12,
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
                        ),
                        onPressed: () async {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                                  email: "ahmed0043ali12@gmail.com",
                                  password: "instructor");

                          String userId = userCredential.user.uid;
                          String userEmail = userCredential.user.email;
                          print("student ID $userId");
                          print("student email ${userCredential.user.email}");
                          FirebaseUtilities.saveUserEmail(userEmail);
                          FirebaseUtilities.saveUserId(userId);
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
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Text(
                          MyLocalization.of(context)
                              .getTranslatedValue("student"),
                          style: textDirection == TextDirection.ltr
                              ? Utilities.getUbuntuTextStyleWithSize(
                                  14,
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                )
                              : Utilities.getTajwalTextStyleWithSize(
                                  12,
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
                        ),
                        onPressed: () async {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                                  email: "ahmed43ali12@gmail.com",
                                  password: "student");

                          String userId = userCredential.user.uid;
                          String userEmail = userCredential.user.email;
                          print("student ID $userId");
                          print("student email ${userCredential.user.email}");
                          FirebaseUtilities.saveUserEmail(userEmail);
                          FirebaseUtilities.saveUserId(userId);
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
