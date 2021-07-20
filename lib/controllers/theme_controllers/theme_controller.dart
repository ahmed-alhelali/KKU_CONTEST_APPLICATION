
import '../../imports.dart';

class ThemeController extends ChangeNotifier {
  bool _isDark = false;
  ThemePreferences _preferences =  ThemePreferences();
  bool get isDark => _isDark;

  ThemeController (){
    _isDark = false;
    _preferences = ThemePreferences();
    getPreferences();
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

  set isDark (bool value){
    _isDark = value;
    setCurrentStatusNavigationBarColor(value);

    _preferences.setTheme(value);
    notifyListeners();
  }
  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}