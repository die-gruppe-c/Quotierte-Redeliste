import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/resources/room_websocket.dart';

class WantToSpeakList extends StatefulWidget {
  final List<User> users;

  WantToSpeakList(this.users, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WantToSpeakListState();
}

class _WantToSpeakListState extends State<WantToSpeakList> {
  RoomWebSocket _webSocket = Repository().webSocket();
  List<User> _usersWantToSpeak;

  @override
  void initState() {
    super.initState();
    _usersWantToSpeak = List();

    _webSocket.getUsersWantToSpeak().listen((List<String> wantToSpeak) {
      List<User> newWantToSpeakList = List();

      wantToSpeak.forEach((userId) {
        newWantToSpeakList.add(widget.users.firstWhere((user) {
          return user.id == userId;
        }));
      });

      setState(() {
        _usersWantToSpeak = newWantToSpeakList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _usersWantToSpeak.length != 0
        ? _getList(_usersWantToSpeak)
        : Text("Keine Meldungen");
  }

  Widget _getList(List<User> list) {
    return Expanded(
        child: ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, pos) {
        return _getListViewItem(list[pos]);
      },
    ));
  }

  Widget _getListViewItem(User user) {
    return Padding(
        padding: EdgeInsets.only(bottom: 2.0, left: 4, right: 4),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: Text(
              user.name,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ));
  }
}
