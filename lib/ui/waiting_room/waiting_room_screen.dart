import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/resources/room_websocket.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/user_widget.dart';

import '../moderator_screen/moderator_screen.dart';

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

  @override
  void initState() {
    super.initState();

    _stateSubscription = widget.webSocket.getRoomState().listen((state) {
      if (state == RoomState.STARTED) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ModeratorScreen()),
        );
      } else {
        setState(() {
          _state = state;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stateSubscription.cancel();
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
            body: navigateOrShowContent(context)));
  }

  Widget navigateOrShowContent(BuildContext context) {
    if (_state == RoomState.ERROR) {
      return Container(
          child: Text("Error: " + widget.webSocket.getErrorMessage()));
    } else if (_state == RoomState.DISCONNECTED) {
      return Container(child: Text("Disconnected"));
    } else {
      return Row(children: [_getList()]);
    }
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
