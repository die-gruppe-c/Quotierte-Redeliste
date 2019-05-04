import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/resources/room_websocket.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/all_users_list.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/speaking_list.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/want_to_speak_list.dart';

class ModeratorScreen extends StatefulWidget {
  @override
  _ModeratorScreenState createState() => _ModeratorScreenState();
}

class _ModeratorScreenState extends State<ModeratorScreen> {
  String roomName = "Test";

  RoomWebSocket _webSocket = Repository().webSocket();

  _ModeratorScreenState() {
    _webSocket.connect();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              title: Text(roomName),
            ),
            body: StreamBuilder(
              stream: _webSocket.getAllUsers(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? _buildForTablet(snapshot.data)
                    : _getLoadingIndicator();
              },
            )));
  }

  Widget _buildForTablet(List<User> users) {
    return Row(
      children: [
        // All users
        Flexible(
            flex: 10,
            child: Column(
              children: [
                _getTitle(context, "Alle Teilnehmer"),
                AllUsersList(users),
              ],
            )),
        // speaking list
        Flexible(
            flex: 12,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(spreadRadius: -1, blurRadius: 5)]),
                child: Column(
                  children: [
                    _getTitle(context, "Redeliste"),
                    SpeakingList(users),
                  ],
                ))),
        // want to speak
        Flexible(
            flex: 10,
            child: Column(
              children: [
                _getTitle(context, "Meldungen"),
                WantToSpeakList(users),
              ],
            )),
      ],
    );
  }

  Widget _getTitle(BuildContext context, String title) {
    return Row(children: [
      Expanded(
          child: Container(
              color: Theme.of(context).disabledColor,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                title,
                textAlign: TextAlign.center,
              )))
    ]);
  }

  Widget _getLoadingIndicator() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CircularProgressIndicator(),
                Padding(padding: EdgeInsets.only(right: 20)),
                Text('Lade Daten...')
              ]),
        ]);
  }
}
