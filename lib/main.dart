import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kku_contest_app/screens/wrapper_screen.dart';
import 'package:provider/provider.dart';
import 'localization/my_localization.dart';
import 'models/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(

      systemNavigationBarColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
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
    return MaterialApp(
      title: 'KKU Context App',
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
      home: WrapperScreen(),
    );
  }
}
