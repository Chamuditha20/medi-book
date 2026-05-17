import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // මුලින්ම ඇප් එක Light Mode එකෙන් පටන් ගන්නේ
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Dark Mode එක On/Off කරන Function එක
  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // ඇප් එකේ හැම තැනටම කියනවා වර්ණය වෙනස් කරන්න කියලා
  }
}