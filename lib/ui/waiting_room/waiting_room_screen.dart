import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/resources/room_websocket.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/user_widget.dart';

class WaitingRoomScreen extends StatefulWidget {
  final RoomWebSocket webSocket = Repository().webSocket();

  WaitingRoomScreen() {
    webSocket.connect();
  }

  @override
  State<StatefulWidget> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Warteraum"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _getFloatingActionButton(),
        body: Row(
          children: [_getList()],
        ));
  }

  Widget _getList() {
    return StreamBuilder(
      stream: widget.webSocket.getAllUsers(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? _buildWithData(context, snapshot.data)
            : _getLoadingIndicator();
      },
    );
  }

  Widget _buildWithData(BuildContext context, List<User> users) {
    return Expanded(
        child: ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, pos) {
        return UserWidget(users[pos]);
      },
    ));
  }

  Widget _getLoadingIndicator() {
    return Expanded(
//      constraints: BoxConstraints.expand(),
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              CircularProgressIndicator(),
              Padding(padding: EdgeInsets.only(right: 20)),
              Text('Lade Daten...')
            ])
      ],
    ));
  }

  Widget _getFloatingActionButton() {
    return FloatingActionButton.extended(
        label: new Text('Start'),
        icon: Icon(Icons.play_arrow),
        onPressed: () {
          widget.webSocket.start();
          // TODO open moderator screen
        });
  }
}
