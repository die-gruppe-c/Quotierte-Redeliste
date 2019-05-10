import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/ui/create_room/create_room_screen.dart';
import 'package:quotierte_redeliste/ui/display_profile/profile_screen.dart';
import 'package:quotierte_redeliste/ui/start_screen/enter_new_room_tab.dart';
import 'package:quotierte_redeliste/ui/start_screen/history_tab.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setAppbar(context),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(children: <Widget>[
          Expanded(
            child: new Container(
                margin: const EdgeInsets.only(left: 16.0, right: 20.0),
                child: Divider(
                  color: Theme.of(context).accentColor,
                  height: 40,
                )),
          ),
          Text("Raum beitreten"),
          Expanded(
            child: new Container(
                margin: const EdgeInsets.only(left: 20.0, right: 16.0),
                child: Divider(
                  color: Theme.of(context).accentColor,
                  height: 40,
                )),
          ),
        ]),
        EnterNewRoomTab(),
        Row(children: <Widget>[
          Expanded(
            child: new Container(
                margin: const EdgeInsets.only(left: 16.0, right: 20.0),
                child: Divider(
                  color: Theme.of(context).accentColor,
                  height: 40,
                )),
          ),
          Text("Vergangene Räume"),
          Expanded(
            child: new Container(
                margin: const EdgeInsets.only(left: 20.0, right: 16.0),
                child: Divider(
                  color: Theme.of(context).accentColor,
                  height: 40,
                )),
          ),
        ]),
        HistoryTab(),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: setFloatingActionButton(context),
    );
  }

  Widget setAppbar(context) {
    return AppBar(
      title: Text('Quoty'),
      actions: <Widget>[
        IconButton(
          icon: new Icon(
            Theme.of(context).brightness == Brightness.light
                ? Icons.brightness_5
                : Icons.brightness_7,
          ),
          onPressed: () {
            DynamicTheme.of(context).setBrightness(
                Theme.of(context).brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark);
          },
        ),
        IconButton(
          icon: Icon(Icons.speaker_notes),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/room/moderator");
          },
        ),
        IconButton(
          // TODO remove only for testing
          icon: Icon(Icons.account_circle),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget setFloatingActionButton(context) {
    return FloatingActionButton.extended(
        icon: Icon(Icons.add),
        onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateRoomScreen()),
            ),
        label: new Text('Raum erstellen'));
  }
}
