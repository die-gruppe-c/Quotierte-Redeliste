import 'package:flutter/material.dart';
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
//          automaticallyImplyLeading: false,
            ),
            body: StreamBuilder(
              stream: _webSocket.getAllUsers(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? Row(
                        children: [
                          AllUsersList(snapshot.data),
                          SpeakingList(snapshot.data),
                          WantToSpeakList(snapshot.data),
                        ],
                      )
                    : _getLoadingIndicator();
              },
            )));
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
