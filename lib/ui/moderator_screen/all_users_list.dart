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
  List<User> _sortedUsers;

  @override
  void initState() {
    super.initState();
    _sortedUsers = widget.users;

    _webSocket.getAllUsersSorted().listen((List<String> sortedList) {
      setState(() {
        _sortedUsers.sort((User userA, User userB) {
          int sortNumberA = sortedList.indexOf(userA.id);
          int sortNumberB = sortedList.indexOf(userB.id);
          return sortNumberA.compareTo(sortNumberB);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _sortedUsers.length != 0
        ? _getList(_sortedUsers)
        : Text("Keine Daten vorhanden");
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
