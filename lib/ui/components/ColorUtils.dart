import 'dart:ui';

import 'package:flutter/material.dart';

class ColorUtils {
  static Color getFontColorForBackground(Color background) {
    final int maxBrightness = 255 + 500 + 255;
    double brightness =
        background.red + background.green * 2.5 + background.blue;

    if (brightness < maxBrightness / 2) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
