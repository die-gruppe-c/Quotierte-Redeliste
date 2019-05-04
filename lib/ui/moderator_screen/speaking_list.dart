import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/resources/room_websocket.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/user_widget.dart';

class SpeakingList extends StatefulWidget {
  final List<User> users;

  SpeakingList(this.users, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SpeakingListState();
}

class _SpeakingListState extends State<SpeakingList> {
  RoomWebSocket _webSocket = Repository().webSocket();
  List<User> _usersSpeakingList;

  @override
  void initState() {
    super.initState();
    _usersSpeakingList = List();

    _webSocket.getSpeakingList().listen((List<String> speakingList) {
      List<User> newSpeakingList = List();

      speakingList.forEach((userId) {
        newSpeakingList.add(widget.users.firstWhere((user) {
          return user.id == userId;
        }));
      });

      setState(() {
        _usersSpeakingList = newSpeakingList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _usersSpeakingList.length != 0
        ? _getList(_usersSpeakingList)
        : Text("Keine Redner");
  }

  Widget _getList(List<User> list) {
    return Expanded(
        child: ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, pos) {
        return UserWidget(list[pos]);
      },
    ));
  }
}
