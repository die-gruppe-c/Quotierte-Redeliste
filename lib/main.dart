// This sample shows adding an action to an [AppBar] that opens a shopping cart.

import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/moderator_screen.dart';
import 'package:quotierte_redeliste/ui/start_screen/start_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white, //top bar color
    statusBarIconBrightness: Brightness.dark, //top bar icons
    systemNavigationBarColor: Colors.white, //bottom bar color
    systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
  ));
  runApp(MyApp());
}

const PRIMARY_COLOR = Colors.white;
const PRIMARY_COLOR_DARK = Colors.black87;
const HINT_COLOR = Colors.black38;
const ACCENT_COLOR = Colors.red;
const DISABLED_COLOR = Colors.black26;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quoty',
      theme: ThemeData(
        primaryColor: PRIMARY_COLOR,
        primaryColorDark: PRIMARY_COLOR_DARK,
        hintColor: HINT_COLOR,
        textSelectionColor: ACCENT_COLOR,
        textSelectionHandleColor: ACCENT_COLOR,
        cursorColor: ACCENT_COLOR,
        accentColor: ACCENT_COLOR,
        disabledColor: DISABLED_COLOR,
        textTheme:
            TextTheme(display1: TextStyle(color: HINT_COLOR, fontSize: 20.0)),
        buttonTheme: ButtonThemeData(
            buttonColor: ACCENT_COLOR,
            textTheme: ButtonTextTheme.primary,
            colorScheme: ColorScheme.light(primary: PRIMARY_COLOR_DARK)),
      ),
      home: StartScreen(),
      routes: {
        "/room/moderator": (_) => new ModeratorScreen(),
      },
    );
  }
}
