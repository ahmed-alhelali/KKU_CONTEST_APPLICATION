import 'package:kku_contest_app/imports.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void changeAppTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    bool currentValue = !isOn;
    setCurrentStatusNavigationBarColor(currentValue);
    themeColor(currentValue);
    WidgetsBinding.instance.addPostFrameCallback((_){
      notifyListeners();
    });
  }

  setCurrentStatusNavigationBarColor(bool isLightTheme) {
    if (isLightTheme == true) {
      return SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ));
    } else {
      return SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ));
    }
  }

  ThemeColor themeColor(bool isLightTheme) {
    return ThemeColor(
      textColor: isLightTheme ? Colors.black : Colors.white,
      toggleButtonColor: isLightTheme ? Color(0xFFFFFFFF) : Color(0xFf34323d),
      toggleBackgroundColor:
      isLightTheme ? Color(0xFFe7e7e8) : Color(0xFF222029),
    );
  }


}



class AppTheme {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: HexColor('#14191F'),
    primaryColor: Colors.black,
    backgroundColor: HexColor('#1d242c'),
    colorScheme: ColorScheme.dark(),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      brightness: Brightness.dark,
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.grey.shade200,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light(),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
      brightness: Brightness.light,
    ),
  );
}

class ThemeColor {
  Color backgroundColor;
  Color toggleButtonColor;
  Color toggleBackgroundColor;
  Color textColor;
  List<BoxShadow> shadow;

  ThemeColor({
    this.backgroundColor,
    this.toggleBackgroundColor,
    this.toggleButtonColor,
    this.textColor,
    this.shadow,
  });
}