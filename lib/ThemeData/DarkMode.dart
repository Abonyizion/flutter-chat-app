import 'package:flutter/material.dart';


ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
   // background: Colors.grey.shade900,
    brightness: Brightness.dark,
    primary: Colors.white,
   primaryContainer: Colors.grey[700],
   // surface: Colors.grey.shade600,
    secondary: Colors.black,
   // tertiary: Colors.grey.shade700,
    inversePrimary: Colors.grey.shade700,
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 2,
  ),
  cardTheme: CardTheme(
    color: Colors.grey[900]
  ),
  hintColor: Colors.grey[400],
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
  ),
);

