import 'package:connected/imports.dart';

class AppTheme {
    static ThemeData appTheme(bool isLightTheme) {
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
      errorColor: isLightTheme ? Colors.grey : HexColor("#29333E"),
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
