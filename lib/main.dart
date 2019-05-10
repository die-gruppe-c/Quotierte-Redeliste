import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/moderator_screen.dart';
import 'package:quotierte_redeliste/ui/start_screen/start_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //statusBarColor: Colors.white, //top bar color TODO: Fehler in der Anzeige
    //statusBarIconBrightness: Brightness.light, //top bar icons
    systemNavigationBarColor: Colors.white, //bottom bar color
    systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
  ));
  runApp(MyApp());
}

const PRIMARY_COLOR = Colors.green;
const PRIMARY_COLOR_DARK = Colors.black87;
const HINT_COLOR = Colors.black38;
const ACCENT_COLOR = Colors.red;
const DISABLED_COLOR = Colors.black26;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
              /*toggleableActiveColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.redAccent[200]
                      : (Theme.of(context).accentColor ?? Colors.red[600]),
              accentColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.redAccent[200]
                  : Colors.red[500],*/
              primarySwatch: ACCENT_COLOR,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Quoty',
            theme: theme,
            home: StartScreen(),
            routes: {
              "/room/moderator": (_) => new ModeratorScreen(),
            },
          );
        });
  }
}

/*
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quoty',
      /*theme: ThemeData(
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
      ),*/
      home: StartScreen(),
      routes: {
        "/room/moderator": (_) => new ModeratorScreen(),
      },
    );
  }
}*/
