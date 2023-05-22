import 'dart:math';

import 'package:flutter/material.dart';

abstract class CustomColors {
  CustomColors._();

  static const Color ICON_BACKGROUND = Colors.deepPurple;
  static const Color LIGHT_BLUE = Colors.lightBlue;

  static Color darker(Color c) {
    return change(c, 0.8);
  }

  static Color lighter(Color c) {
    return change(c, 1.2);
  }

  static Color change(Color c, double ratio) {
    assert(ratio > 0);
    return Color.fromARGB(
      c.alpha,
      min((c.red * ratio).round(), 0xFF),
      min((c.green * ratio).round(), 0xFF),
      min((c.blue * ratio).round(), 0xFF),
    );
  }
}
