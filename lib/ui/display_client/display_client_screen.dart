import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/room.dart';
import 'package:quotierte_redeliste/models/speaking_category.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/resources/room_websocket.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/user_widget.dart';

class ClientScreen extends StatefulWidget {
  final RoomWebSocket webSocket = Repository().webSocket();

  final int roomId;
  ClientScreen(this.roomId, {Key key}) : super(key: key);

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  Room _room;
  RoomState _state;
  StreamSubscription _stateSubscription;
  StreamSubscription _roomSubscription;

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
      setState(() {
        _state = state;
      });
    });

    _roomSubscription = widget.webSocket.getRoomData().listen((room) {
      setState(() {
        _room = room;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stateSubscription.cancel();
    _roomSubscription.cancel();
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
              title: Text('Raum: ' + _room.name),
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
      return Column(children: [_list(), _buttons2()]);
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

  Widget _buttons2() {
    return Container(
        color: Theme.of(context).appBarTheme.color,
        padding: EdgeInsets.only(bottom: 30.0, top: 30.0),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.color,
          border: Border(top: BorderSide(color: Theme.of(context).accentColor)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildButtonColumn(
                Theme.of(context).accentColor,
                Icon(Icons.error_outline),
                'Meldung',
                widget.webSocket.wantToSpeak(SpeakingCategory('Meldung', '1'))),
            _buildButtonColumn(
                Theme.of(context).accentColor,
                Icon(Icons.record_voice_over),
                'Reden',
                widget.webSocket.wantToSpeak(SpeakingCategory('Reden', '2'))),
            _buildButtonColumn(
                Theme.of(context).accentColor,
                Icon(Icons.info_outline),
                'Anmerkung',
                widget.webSocket
                    .wantToSpeak(SpeakingCategory('Anmerkung', '3'))),
          ],
        ));
  }

  Widget _list() {
    return StreamBuilder(
      stream: widget.webSocket.getSpeakingList(),
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
            "Aktueller Redner: " + users[0].name,
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

  Column _buildButtonColumn(
      Color color, Widget icon, String label, Function function) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatButton(
          onPressed: function,
          color: Theme.of(context).accentColor,
          textColor: Theme.of(context).accentColor,
          shape: StadiumBorder(),
          child: Column(
            children: <Widget>[icon, Text(label)],
          ),
        )
      ],
    );
  }
}
