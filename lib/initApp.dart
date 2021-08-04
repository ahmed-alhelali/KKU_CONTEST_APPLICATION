import 'package:connected/imports.dart';

import 'controllers/theme_controllers/theme_controller.dart';

init() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool seen = prefs.getBool('seen');
  bool student = prefs.getBool('student');

  Widget _screen;
  if (seen == null || seen == false) {
    _screen = WrapperScreen();
  } else {
    if (student == false || student == null) {
      var userName = await FirebaseUtilities.getUserName();
      var userImageUrl = await FirebaseUtilities.getUserImageUrl();
      var userID = await FirebaseUtilities.getUserId();

      _screen = LifeCycleManager(
          child: InstructorWrapperScreen(
        userName: userName,
        userURLImage: userImageUrl,
        userID: userID,
      ));
    } else {
      var userName = await FirebaseUtilities.getUserName();
      var userImageUrl = await FirebaseUtilities.getUserImageUrl();
      var userID = await FirebaseUtilities.getUserId();

      _screen = LifeCycleManager(
        child: StudentWrapperScreen(
          userName: userName,
          userURLImage: userImageUrl,
          uid: userID,
        ),
      );
    }
  }

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => Authentication(),
        ),
        ChangeNotifierProvider<MultipleNotifier>(
          create: (_) => MultipleNotifier([]),
        ),
      ],
      child: MyApp(_screen),
    ),
  );
}

class MyApp extends StatefulWidget {
  Widget screen;

  MyApp(this.screen);

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  getInitialLanguage()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getString("isEn") == "ar" || preferences.getString("isEn") == null){
      _locale = Locale('ar', '');
    }else{
      _locale = Locale('en', '');
    }
  }
  @override
  void initState() {
    getInitialLanguage();
    super.initState();
  }
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: Consumer(builder: (context, ThemeController themeNotifier, child) {
        return MaterialApp(
          title: 'Connected',
          theme: AppTheme.appTheme(themeNotifier.isDark),
          localizationsDelegates: [
            MyLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: child,
            );
          },
          debugShowCheckedModeBanner: false,
          locale: _locale,
          supportedLocales: [
            const Locale('en', ''),
            const Locale('ar', ''),
          ],
          localeResolutionCallback: (currentLocate, supportedLocates) {
            if (currentLocate != null) {
              for (Locale locale in supportedLocates) {
                if (currentLocate.languageCode == locale.languageCode) {
                  return currentLocate;
                }
              }
            }
            return supportedLocates.first;
          },
          home: widget.screen,
        );
      }),
    );
  }
}
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
