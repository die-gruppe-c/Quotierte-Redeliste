import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/moderator_screen.dart';
import 'package:quotierte_redeliste/ui/start_screen/start_screen.dart';

const PRIMARY_COLOR = Colors.white;
const PRIMARY_COLOR_DARK = Colors.black87;
const HINT_COLOR = Colors.black38;
const ACCENT_COLOR = Colors.red;
const DISABLED_COLOR = Colors.black26;

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // TODO change when darkmode changes
    systemNavigationBarColor: Colors.white, //bottom bar color
    systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) {
          if (brightness == Brightness.light) {
            return ThemeData(
                primaryColor: PRIMARY_COLOR,
                primaryColorDark: PRIMARY_COLOR_DARK,
                hintColor: HINT_COLOR,
                textSelectionColor: ACCENT_COLOR,
                textSelectionHandleColor: ACCENT_COLOR,
                cursorColor: ACCENT_COLOR,
                accentColor: ACCENT_COLOR,
                disabledColor: DISABLED_COLOR,
                textTheme: TextTheme(
                    display1: TextStyle(color: HINT_COLOR, fontSize: 20.0)),
                buttonTheme: ButtonThemeData(
                    buttonColor: ACCENT_COLOR,
                    textTheme: ButtonTextTheme.primary,
                    colorScheme:
                        ColorScheme.light(primary: PRIMARY_COLOR_DARK)),
                brightness: brightness);
          } else {
            return ThemeData(
              scaffoldBackgroundColor: Colors.grey[850],
              primarySwatch: ACCENT_COLOR,
              brightness: brightness,
            );
          }
        },
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
