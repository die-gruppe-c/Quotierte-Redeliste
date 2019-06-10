import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quotierte_redeliste/models/profile.dart';
import 'package:quotierte_redeliste/ui/create_room/create_room_screen.dart';
import 'package:quotierte_redeliste/ui/display_profile/profile_screen.dart';
import 'package:quotierte_redeliste/ui/start_screen/enter_new_room_tab.dart';
import 'package:quotierte_redeliste/ui/start_screen/history_tab.dart';
import 'package:quotierte_redeliste/ui/waiting_room/waiting_room_screen.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setAppbar(context),
      body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        _setEnterRoomCard(context),
        _setHistoryRoomTitle(context),
        HistoryTab()
      ])),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: setFloatingActionButton(context),
    );
  }

  Widget setAppbar(context) {
    return AppBar(
      title: Text('Quoty'),
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      textTheme: Theme.of(context).textTheme,
      iconTheme: Theme.of(context).iconTheme,
      //actionsIconTheme: Theme.of(context).iconTheme,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.speaker_notes),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WaitingRoomScreen()),
            );
          },
        ),
        Profile.isInDebugMode()
            ? IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
              )
            : Container(),
      ],
    );
  }

  Widget _setEnterRoomCard(context) {
    return Center(
      child: Card(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        elevation: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(MdiIcons.login),
              title: Text('Raumbeitritt'),
              subtitle: Text('Gebe die vierstellige ID des Raumes in das un'),
            ),
            Padding(
                padding: EdgeInsets.only(top: 6, bottom: 6),
                child: EnterNewRoomTab()),
          ],
        ),
      ),
    );
  }

  Widget _setHistoryRoomTitle(context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(MdiIcons.history),
            title: Text('Raumhistorie'),
            subtitle: Text('In der Vergangenheit betretene Räume'),
          ),
        ],
      ),
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
