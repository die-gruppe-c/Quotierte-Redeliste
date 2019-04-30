import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/resources/room_websocket.dart';

class AllUsersList extends StatefulWidget {
  final List<User> users;

  AllUsersList(this.users, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AllUsersListState();
}

class _AllUsersListState extends State<AllUsersList> {
  RoomWebSocket _webSocket = Repository().webSocket();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
