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
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        systemNavigationBarColor: HexColor('#14191F'),
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ));
    }
  }

  ThemeData themeAPP(bool isLightTheme) {
    return ThemeData(
      scaffoldBackgroundColor:
          isLightTheme ? Colors.white : HexColor('#14191F'),
      primaryColor: isLightTheme ? Colors.black : Colors.grey,
      backgroundColor:
          isLightTheme ? Colors.grey.shade200 : HexColor('#1d242c'),
      colorScheme: isLightTheme ? ColorScheme.light() : ColorScheme.dark(),
      appBarTheme: AppBarTheme(
        iconTheme:
            IconThemeData(color: isLightTheme ? Colors.black : Colors.white),
        brightness: isLightTheme ? Brightness.light : Brightness.dark,
      ),
      iconTheme:
          IconThemeData(color: isLightTheme ? Colors.black87 : Colors.grey),
      textTheme: TextTheme(
        caption: TextStyle(
          color: isLightTheme ? Colors.black : Colors.white,
        ),
      ),
      disabledColor: isLightTheme ? Colors.black26 : Colors.grey,
      shadowColor: isLightTheme ? Colors.black54 : Colors.white10,
      dividerColor: isLightTheme ? Colors.grey : Colors.white54,
      cardColor: isLightTheme ? Colors.grey.shade300 : HexColor("#29333E"),
      canvasColor: isLightTheme ? Colors.black : Colors.white,

      accentColor: isLightTheme ? Colors.blue.shade100 : Colors.grey,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.red,
        backgroundColor: Colors.green.shade800,
        highlightElevation: 0,
        elevation: 0,
      ),
    );
  }
}
