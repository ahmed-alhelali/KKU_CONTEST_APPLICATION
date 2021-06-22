import 'package:kku_contest_app/imports.dart';

init() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool seen = prefs.getBool('seen');
  bool student = prefs.getBool('student');

  Widget _screen;
  if (student == false || student == null) {
    if (seen == null || seen == false) {
      _screen = WrapperScreen();
    } else {
      var userName = await FirebaseUtilities.getUserName();
      var userImageUrl = await FirebaseUtilities.getUserImageUrl();
      var userID = await FirebaseUtilities.getUserId();
      _screen = InstructorWrapperScreen(
        userName: userName,
        userURLImage: userImageUrl,
        userID: userID,
      );
    }
  } else {
    if (seen == null || seen == false) {
      _screen = WrapperScreen();
    } else {
      var userName = await FirebaseUtilities.getUserName();
      var userImageUrl = await FirebaseUtilities.getUserImageUrl();
      var userID = await FirebaseUtilities.getUserId();
      _screen = StudentWrapperScreen(
        userName: userName,
        userURLImage: userImageUrl,
        uid: userID,
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
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: MyApp(_screen),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  Widget seen;

  MyApp(this.seen);

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.isDarkMode ? false : true;
    return MaterialApp(
      title: 'KKU Context App',
      theme: ThemeProvider().themeAPP(isLightTheme),
      localizationsDelegates: [
        MyLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
      // home: WrapperScreen(),
      home: widget.seen,
    );
  }
}