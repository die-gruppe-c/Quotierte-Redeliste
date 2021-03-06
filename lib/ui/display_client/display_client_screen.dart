import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/currently_speaking.dart';
import 'package:quotierte_redeliste/models/room.dart';
import 'package:quotierte_redeliste/models/speaking_list_entry.dart';
import 'package:quotierte_redeliste/models/speech_type.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/resources/room_websocket.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/user_widget.dart';
import 'package:quotierte_redeliste/ui/start_screen/start_screen.dart';

class ClientScreen extends StatefulWidget {
  final RoomWebSocket webSocket = Repository().webSocket();

  final int roomId;
  ClientScreen(this.roomId, {Key key}) : super(key: key);

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen>
    implements UserWidgetInteraction {
  Room _room;
  List<User> _allUsers;
  String ownUserId;

  RoomState _state;
  StreamSubscription _stateSubscription;
  StreamSubscription _roomSubscription;
  StreamSubscription _usersSubscription;

  @override
  void initState() {
    super.initState();
    _startConnection(connectToWebSocket: false);
  }

  _startConnection({connectToWebSocket: true}) {
    setState(() {
      _state = null;
    });

    if (connectToWebSocket) widget.webSocket.connect();

    _stateSubscription = widget.webSocket.getRoomState().listen((state) {
      if (state == RoomState.ARCHIVED) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => StartScreen()));
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
    });

    _usersSubscription = widget.webSocket.getAllUsers().listen((users) {
      setState(() {
        _allUsers = users;
        ownUserId = users.firstWhere((user) => user.isOwnUser()).id;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stateSubscription.cancel();
    _roomSubscription.cancel();
    _usersSubscription.cancel();
  }

  Future<bool> _onWillPop() async {
    widget.webSocket.close();
    return true;
  }

  User _getUserById(String userId) {
    return _allUsers.firstWhere((searchUser) => searchUser.id == userId);
  }

  @override
  void next() => widget.webSocket.stopSpeech();

  @override
  void pause() => widget.webSocket.pauseSpeech();

  @override
  void resume() => widget.webSocket.startSpeech();

  _notWantToSpeak() => widget.webSocket.doNotWantToSpeak();

  // -------------- BUILD ------------------

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              title:
                  _room != null ? Text('Raum: ' + _room.name) : Text("Loading"),
            ),
            body: showContentOrError(context)));
  }

  Widget showContentOrError(BuildContext context) {
    if (_state == RoomState.ERROR) {
      return _showError("Error: " + widget.webSocket.getErrorMessage());
    } else if (_state == RoomState.DISCONNECTED) {
      return _showError(
          "Verbindung verloren \n\n" + widget.webSocket.getErrorMessage());
    } else {
      return Column(children: [_list(), _bottomRowStreamListener()]);
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

  Widget _bottomRowStreamListener() {
    return StreamBuilder(
        stream: widget.webSocket.getWantToSpeakStatus(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          bool selfWantToSpeak = snapshot.hasData && snapshot.data;

          return Container(
              color: Theme.of(context).appBarTheme.color,
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.color,
                border: Border(
                    top: BorderSide(color: Theme.of(context).accentColor)),
              ),
              child: selfWantToSpeak
                  ? _bottomRowWhileWantToSpeak()
                  : _bottomRowWithButtons());
        });
  }

  Widget _bottomRowWithButtons() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: SpeechType.values.map((type) {
          String typeString = type.toString().split('.').last;
          return _buildBottomButton(Icon(SpeechTypeUtils.iconForEnum(type)),
              typeString, () => widget.webSocket.wantToSpeak(typeString));
        }).toList());
  }

  Widget _bottomRowWhileWantToSpeak() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
              padding: EdgeInsets.all(30),
              child: Text("Meldung zurückziehen"),
              onPressed: _notWantToSpeak)
        ],
      );

  Widget _list() => StreamBuilder(
        stream: widget.webSocket.getSpeakingList(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _buildWithData(context, snapshot.data)
              : _getLoadingIndicator();
        },
      );

  Widget _buildWithData(BuildContext context, List<SpeakingListEntry> users) {
    return Expanded(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _currentlySpeakingWidget(),
      Expanded(
          child: ListView.builder(
              padding: EdgeInsets.only(bottom: 80),
              itemCount: users.length,
              itemBuilder: (context, pos) => UserWidget(
                  _getUserById(users[pos].id),
                  speechCategory: users[pos].speechType)))
    ]));
  }

  Widget _currentlySpeakingWidget() => StreamBuilder(
      stream: widget.webSocket.getCurrentlySpeaking(),
      builder: (context, AsyncSnapshot<CurrentlySpeaking> snapshot) {
        if (snapshot.hasData && snapshot.data.speakerId != null) {
          User currentlySpeaking = _getUserById(snapshot.data.speakerId);
          if (currentlySpeaking.isOwnUser()) {
            return UserWidget(currentlySpeaking,
                currentlySpeaking: snapshot.data,
                userWidgetInteraction: this,
                speechCategory: snapshot.data.speechTypeId);
          } else {
            return Container(
                decoration: BoxDecoration(color: Theme.of(context).splashColor),
                padding: EdgeInsets.all(10),
                child: Text(
                    "Aktueller Redner: " +
                        _getUserById(snapshot.data.speakerId).name,
                    textAlign: TextAlign.center));
          }
        } else {
          return Container();
        }
      });

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

  Column _buildBottomButton(Widget icon, String label, VoidCallback function) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatButton(
          padding: EdgeInsets.all(30),
          onPressed: function,
          child: Column(
            children: [
              icon,
              Padding(padding: EdgeInsets.only(top: 5)),
              Text(label)
            ],
          ),
        )
      ],
    );
  }
}
