import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/resources/room_websocket.dart';
import 'package:quotierte_redeliste/ui/components/ResponsiveContainer.dart';
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
        onWillPop: () async => true,
        child: ResponsiveContainer.isTablet(context)
            ? _buildScaffold(context)
            : DefaultTabController(length: 3, child: _buildScaffold(context)));
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(roomName),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _floatingActionButton(context),
        body: StreamBuilder(
          stream: _webSocket.getAllUsers(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? _buildWithData(context, snapshot.data)
                : _getLoadingIndicator();
          },
        ));
  }

  Widget _floatingActionButton(context) {
    return FloatingActionButton.extended(
        icon: Icon(Icons.play_arrow),
        onPressed: () => _webSocket.start(),
        label: new Text('Start'));
  }

  Widget _buildWithData(BuildContext context, List<User> users) {
    return ResponsiveContainer.isTablet(context)
        ? _buildForTablet(users)
        : _buildForPhone(users);
  }

  Widget _buildForPhone(List<User> users) {
    return TabBarView(children: [
      Row(children: [AllUsersList(users)]),
      Row(children: [SpeakingList(users)]),
      Row(children: [WantToSpeakList(users)])
    ]);
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
