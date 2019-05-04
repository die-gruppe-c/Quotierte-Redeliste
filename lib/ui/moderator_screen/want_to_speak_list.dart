import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/resources/room_websocket.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/user_widget.dart';

class WantToSpeakList extends StatefulWidget {
  final List<User> users;
  final ScrollController scrollController = ScrollController();

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
      controller: widget.scrollController,
      itemCount: list.length,
      itemBuilder: (context, pos) {
        return UserWidget(
          list[pos],
          onTap: () {
            _addUserToSpeakingList(list[pos].id);
          },
        );
      },
    ));
  }

  _addUserToSpeakingList(String userId) {
    print("Add user to speaking list: " + userId);
    _webSocket.addUserToSpeakingList(userId);
  }
}
