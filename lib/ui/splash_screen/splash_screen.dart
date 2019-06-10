import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quotierte_redeliste/models/profile.dart';
import 'package:quotierte_redeliste/models/room.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/ui/start_screen/start_screen.dart';
import 'package:quotierte_redeliste/ui/waiting_room/waiting_room_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
          Image.asset(
            'assets/images/icon_placeholder.png',
          ),
          Container(
            padding: const EdgeInsets.only(top: 32),
            child: CircularProgressIndicator(),
          )
        ])));
  }

  @override
  void initState() {
    super.initState();

    Profile().darkModeEnabled().then((enabled) {
      DynamicTheme.of(context)
          .setBrightness(enabled ? Brightness.dark : Brightness.light);
    });

    _connectToServer();
  }

  _connectToServer() {
    Repository().getRoomToJoin().then((Room room) {
      var screen;

      if (room == null)
        screen = StartScreen();
      else
        screen = WaitingRoomScreen();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }).catchError((e) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                'Verbindung zum Server konnte nicht hergestellt werden...'),
            actions: [
              FlatButton(
                child: Text('SCHLIESSEN'),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
              FlatButton(
                child: Text('ERNEUT VERSUCHEN'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _connectToServer();
                },
              )
            ],
          );
        },
      );
    });
  }
}
