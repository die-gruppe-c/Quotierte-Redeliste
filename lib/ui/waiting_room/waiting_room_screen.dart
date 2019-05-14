import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/resources/room_websocket.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/moderator_screen.dart';
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
  RoomState _state;
  StreamSubscription _stateSubscription;
  StreamSubscription _roomSubscription;

  @override
  void initState() {
    super.initState();

    _stateSubscription = widget.webSocket.getRoomState().listen((state) {
      if (state == RoomState.STARTED) {
        _navigateToModeratorScreen();
      } else {
        setState(() {
          _state = state;
        });
      }
    });

    _roomSubscription = widget.webSocket.getRoomData().listen((room) {
      print("Room: " + room.toString());
      if (room.running) {
        //_navigateToModeratorScreen();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stateSubscription.cancel();
    _roomSubscription.cancel();
  }

  _navigateToModeratorScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ModeratorScreen()),
    );
  }

  _createNewUser() {
    print("create new user");
    // TODO implement
  }

  Future<bool> _onWillPop() async {
    widget.webSocket.close();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Warteraum"),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _getFloatingActionButton(),
            body: showContentOrError(context)));
  }

  Widget showContentOrError(BuildContext context) {
    if (_state == RoomState.ERROR) {
      return Container(
          child: Text("Error: " + widget.webSocket.getErrorMessage()));
    } else if (_state == RoomState.DISCONNECTED) {
      return Container(child: Text("Disconnected"));
    } else {
      return Column(children: [_addUser(), _getList()]);
    }
  }

  Widget _addUser() {
    return Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Theme.of(context).disabledColor)),
        ),
        child: ListTile(
            onTap: _createNewUser,
            leading: Icon(
              Icons.add_circle_outline,
              size: 40,
              color: Theme.of(context).hintColor,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            title: Row(children: [
              Padding(padding: EdgeInsets.only(right: 16)),
              Text("Benutzer ohne Handy hinzufügen")
            ])));
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
    if (_state != RoomState.ERROR && _state != RoomState.DISCONNECTED)
      return FloatingActionButton.extended(
          label: new Text('Start'),
          icon: Icon(Icons.play_arrow),
          onPressed: () {
            widget.webSocket.start();
          });

    return null;
  }
}
