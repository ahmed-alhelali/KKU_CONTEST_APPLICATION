import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: HexColor('#282033'),
    primaryColor: Colors.black,
    backgroundColor: HexColor('#322840'),
    colorScheme: ColorScheme.dark(),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      brightness: Brightness.dark,
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.grey.shade100,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light(),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
      brightness: Brightness.light,
    ),
  );
}
