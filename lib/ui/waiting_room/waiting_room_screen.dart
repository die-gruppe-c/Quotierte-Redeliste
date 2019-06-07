import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/room.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/resources/room_websocket.dart';
import 'package:quotierte_redeliste/ui/components/custom_snackbar.dart';
import 'package:quotierte_redeliste/ui/display_client/display_client_screen.dart';
import 'package:quotierte_redeliste/ui/enter_room/enter_room_screen.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/moderator_screen.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/user_widget.dart';
import 'package:quotierte_redeliste/ui/start_screen/start_screen.dart';

class WaitingRoomScreen extends StatefulWidget {
  final RoomWebSocket webSocket = Repository().webSocket();

  @override
  State<StatefulWidget> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoomScreen> {
  Room _room;
  RoomState _state;
  StreamSubscription _stateSubscription;
  StreamSubscription _roomSubscription;

  CustomSnackbar _customSnackbar = CustomSnackbar();

  @override
  void initState() {
    super.initState();
    _startConnection();
  }

  _startConnection() {
    setState(() {
      _state = null;
    });
    widget.webSocket.connect();

    _stateSubscription = widget.webSocket.getRoomState().listen((state) {
      if (state == RoomState.STARTED) {
        if (_isModerator()) {
          _navigateToModeratorScreen();
        } else {
          _navigateToClientScreen();
        }
      } else {
        setState(() {
          _state = state;
        });
      }
    });

    _roomSubscription = widget.webSocket.getRoomData().listen((room) {
      setState(() {
        _room = room;
      });

      if (room.running) {
        if (_isModerator())
          _navigateToModeratorScreen();
        else
          _navigateToClientScreen();
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ModeratorScreen()),
    );
  }

  _navigateToClientScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ClientScreen(_room.id)),
    );
  }

  _navigateToMainScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => StartScreen()));
  }

  _createNewUser() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EnterRoomScreen(
                  _room.id.toString(),
                  forOtherUser: true,
                  room: _room,
                ))).then((userCreated) {
      if (userCreated == true) {
        widget.webSocket.updateUserList();
      }
    });
  }

  _leaveRoom() {
    Repository().roomApi.leaveRoom().then((_) {
      _navigateToMainScreen();
    }).catchError((error) {
      _customSnackbar.showError(error);
    });
  }

  bool _isModerator() {
    return _room != null && _room.owner != null && _room.owner != "";
  }

  Future<bool> _onWillPop() async {
    widget.webSocket.close();
    return true;
  }

  // ------------ BUILD -------------

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            key: _customSnackbar.scaffoldKey,
            appBar: AppBar(
              title: Text("Warteraum"),
              actions: [_getRoomIdWidget()],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _getFloatingActionButton(),
            body: showContentOrError(context)));
  }

  Widget _getRoomIdWidget() {
    return _room != null && _room.id != null
        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: Text(
                  "Beitrittscode: " + _room.id.toString(),
                  style: TextStyle(fontSize: 20),
                ))
          ])
        : Container();
  }

  Widget showContentOrError(BuildContext context) {
    if (_state == RoomState.ERROR) {
      return _showError("Error: " + widget.webSocket.getErrorMessage());
    } else if (_state == RoomState.DISCONNECTED) {
      return _showError(
          "Verbindung verloren \n\n" + widget.webSocket.getErrorMessage());
    } else {
      return Column(children: [_addUser(), _getList()]);
    }
  }

  Widget _showError(String error) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Flexible(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(error, textAlign: TextAlign.center),
        Padding(padding: EdgeInsets.only(top: 25)),
        RaisedButton(
          child: Text("Erneut verbinden"),
          onPressed: _startConnection,
        )
      ]))
    ]);
  }

  Widget _addUser() {
    if (_isModerator())
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
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              title: Row(children: [
                Padding(padding: EdgeInsets.only(right: 16)),
                Text("Benutzer ohne Handy hinzufügen")
              ])));
    else {
      return Container();
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
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
          decoration: BoxDecoration(color: Theme.of(context).splashColor),
          padding: EdgeInsets.all(10),
          child: Text(
            "Anzahl Gäste: " + users.length.toString(),
            textAlign: TextAlign.center,
          )),
      Expanded(
          child: ListView.builder(
        padding: EdgeInsets.only(bottom: 80),
        itemCount: users.length,
        itemBuilder: (context, pos) {
          return UserWidget(users[pos]);
        },
      ))
    ]));
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
    if (_state != RoomState.ERROR &&
        _state != RoomState.DISCONNECTED &&
        _isModerator()) {
      return FloatingActionButton.extended(
          label: new Text('Raum starten'),
          icon: Icon(Icons.play_arrow),
          onPressed: () {
            widget.webSocket.start();
          });
    } else if (!_isModerator()) {
      return FloatingActionButton.extended(
          label: new Text('Raum Verlassen'),
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            _leaveRoom();
          });
    }

    return null;
  }
}
