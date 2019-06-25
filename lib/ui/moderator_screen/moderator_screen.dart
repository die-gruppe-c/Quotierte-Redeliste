import 'dart:async';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/room.dart';
import 'package:quotierte_redeliste/models/speech_statistic.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/resources/room_websocket.dart';
import 'package:quotierte_redeliste/ui/components/ResponsiveContainer.dart';
import 'package:quotierte_redeliste/ui/components/Utils.dart';
import 'package:quotierte_redeliste/ui/components/charts/colored_line.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/all_users_list.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/speaking_list.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/want_to_speak_list.dart';
import 'package:quotierte_redeliste/ui/start_screen/start_screen.dart';

class ModeratorScreen extends StatefulWidget {
  @override
  _ModeratorScreenState createState() => _ModeratorScreenState();
}

class _ModeratorScreenState extends State<ModeratorScreen> {
  RoomState _state;
  String _error;

  RoomWebSocket _webSocket = Repository().webSocket();
  StreamSubscription _stateSubscription;

  @override
  void initState() {
    super.initState();
    _initWebSocket();
  }

  @override
  void dispose() {
    super.dispose();
    _stateSubscription.cancel();
    _webSocket.close();
  }

  _initWebSocket({bool reconnect}) {
    if (reconnect == true) {
      _webSocket.connect();

      setState(() {
        _error = null;
        _state = null;
      });
    }

    _stateSubscription = _webSocket.getRoomState().listen((state) {
      if (state == RoomState.ARCHIVED) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => StartScreen()));
      } else {
        setState(() {
          _state = state;
          _error = _webSocket.getErrorMessage();
        });
      }
    });
  }

  _endRoom() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Raum beenden?'),
          actions: [
            FlatButton(
              child: Text(
                'ABBRECHEN',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
            FlatButton(
              child: Text('BEENDEN',
                  style: TextStyle(color: Theme.of(context).accentColor)),
              onPressed: () {
                Navigator.of(context).pop();
                _webSocket.stopSpeech();
                _webSocket.stopRoom();
              },
            )
          ],
        );
      },
    );
  }

  // ------ BUILD ---------

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => true,
        child: ResponsiveContainer.isTablet(context)
            ? _buildScaffold(context)
            : DefaultTabController(length: 3, child: _buildScaffold(context)));
  }

  Widget _buildScaffold(BuildContext context) => Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: _getRoomTitle(),
        actions: [_getEndRoomAction()],
        bottom: ResponsiveContainer.isTablet(context)
            ? null
            : TabBar(
                tabs: [
                  Tab(text: 'Alle Teilnehmer'),
                  Tab(text: 'Redeliste'),
                  Tab(text: 'Meldeliste')
                ],
              ),
      ),
      body: _buildScreenOrShowError(context));

  Widget _getEndRoomAction() {
    return Container(
        padding: EdgeInsets.only(right: 8, top: 12, bottom: 12),
        child: FlatButton(
          color: Theme.of(context).accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          disabledColor: Colors.black12,
          child: Text(
            "Raum beenden",
            style: TextStyle(
                color: Utils.getFontColorForBackground(
                    Theme.of(context).accentColor)),
          ),
          onPressed:
              _state != RoomState.DISCONNECTED && _state != RoomState.ERROR
                  ? _endRoom
                  : null,
        ));
  }

  Widget _getRoomTitle() {
    return StreamBuilder(
        stream: _webSocket.getRoomData(),
        builder: (context, AsyncSnapshot<Room> snapshot) {
          return snapshot.hasData
              ? Text(snapshot.data.name)
              : Text("Lade daten...");
        });
  }

  Widget _buildScreenOrShowError(BuildContext context) {
    return _state != RoomState.DISCONNECTED && _state != RoomState.ERROR
        ? _buildScreenWhenNoError(context)
        : _errorAndReconnect(context);
  }

  Widget _buildScreenWhenNoError(BuildContext context) {
    return StreamBuilder(
        stream: _webSocket.getAllUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) =>
            snapshot.hasData
                ? _buildWithData(context, snapshot.data)
                : _getLoadingIndicator());
  }

  Widget _getLoadingIndicator() => Column(
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

  Widget _errorAndReconnect(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Verbindung unterbrochen"),
        _error != null && _error != "" ? Text(_error) : Container(),
        Padding(padding: EdgeInsets.only(bottom: 10)),
        RaisedButton(
            child: Text("Erneut Verbinden"),
            onPressed: () => _initWebSocket(reconnect: true))
      ],
    );
  }

  Widget _buildWithData(BuildContext context, List<User> users) =>
      Column(children: [
        ResponsiveContainer.isTablet(context)
            ? _buildForTablet(users)
            : _buildForPhone(users),
        _getStatistics(context)
      ]);

  Widget _getStatistics(BuildContext context) => StreamBuilder(
      stream: _webSocket.getRoomData(),
      builder: (context, AsyncSnapshot<Room> room) => room.hasData
          ? StreamBuilder(
              stream: _webSocket.getStatistics(),
              builder: (context, AsyncSnapshot<List<SpeechStatistic>> snapshot) =>
                  !snapshot.hasData
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                              color: DynamicTheme.of(context).data.cardColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12)),
                              boxShadow: [
                                BoxShadow(spreadRadius: -1, blurRadius: 1)
                              ]),
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Container(
                              padding: EdgeInsets.only(top: 8, bottom: 16, left: 8, right: 8),
                              child: Column(children: snapshot.data.map((stat) => ColoredLine(ColorLineData.listFromSpeechStatistic(stat, room.data), stat.attributeName)).toList()))))
          : Container());

  Widget _buildForPhone(List<User> users) => Expanded(
          child: TabBarView(children: [
        Row(children: [AllUsersList(users)]),
        Row(children: [SpeakingList(users)]),
        Row(children: [WantToSpeakList(users)])
      ]));

  Widget _buildForTablet(List<User> users) => Expanded(
          child: Row(children: [
        // All users
        Flexible(
            flex: 10,
            child: Column(children: [
              _getTitle(context, "Alle Teilnehmer"),
              AllUsersList(users)
            ])),
        // speaking list
        Flexible(
            flex: 12,
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    boxShadow: [BoxShadow(spreadRadius: -1, blurRadius: 3)]),
                child: Column(children: [
                  _getTitle(context, "Redeliste"),
                  SpeakingList(users)
                ]))),
        // want to speak
        Flexible(
            flex: 10,
            child: Column(children: [
              _getTitle(context, "Meldungen"),
              WantToSpeakList(users)
            ]))
      ]));

  Widget _getTitle(BuildContext context, String title) => Row(children: [
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
