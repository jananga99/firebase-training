import 'package:flutter/material.dart';

class CustomTheme {
  static Color iconBackground = Colors.white;

  static ThemeData getThemeData() {
    return ThemeData(
        secondaryHeaderColor: Colors.lightBlue,
        iconTheme: const IconThemeData(color: Colors.deepPurple),
        colorScheme: const ColorScheme(
          background: Color(0xff00ffff),
          brightness: Brightness.light,
          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: Colors.green,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          onBackground: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black12,
        )
        // Add more properties here as needed
        );
  }
}
