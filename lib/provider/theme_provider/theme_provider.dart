import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier{
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toogleTheme(bool isOn){
    themeMode = isOn? ThemeMode.dark:ThemeMode.light;
    notifyListeners();
  }
}

class MyTheme{
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.dark(),
    backgroundColor: Colors.grey.shade800,
    splashColor: Colors.grey.shade400,
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFFDEE3EB),
    primaryColor: Colors.black,
    colorScheme: ColorScheme.light(),
    backgroundColor: Color(0xFFFFFFFF),
    splashColor: Color(0xFFF5F7FB),
  );
}