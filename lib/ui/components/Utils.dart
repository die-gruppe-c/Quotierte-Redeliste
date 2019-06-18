import 'dart:ui';

import 'package:flutter/material.dart';

class Utils {
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

  static String getTimeStringFromSeconds(int seconds) {
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;
    String secondsString;
    if (seconds < 10) {
      secondsString = "0" + seconds.toString();
    } else {
      secondsString = seconds.toString();
    }
    return minutes.toString() + ":" + secondsString;
  }
}
