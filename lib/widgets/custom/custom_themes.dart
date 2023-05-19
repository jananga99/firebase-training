import 'package:flutter/material.dart';

abstract class CustomThemes {
  CustomThemes._();

  static lightTheme(context) => ThemeData(
        colorScheme: const ColorScheme(
          background: Color(0xff00ffff),
          onBackground: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          brightness: Brightness.light,
          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: Colors.green,
          onSecondary: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black12,
        ),
      );
}
