import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/resources/room_websocket.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/user_widget.dart';

class AllUsersList extends StatefulWidget {
  final List<User> users;
  final ScrollController scrollController = ScrollController();

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

  void _onUserTap(int pos) {
    _webSocket.addUserToSpeakingList(_sortedUsers[pos].id);
  }

  @override
  Widget build(BuildContext context) {
    return _sortedUsers.length != 0
        ? _getList(_sortedUsers)
        : Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Keine Teilnehmer")]));
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
            _onUserTap(pos);
          },
        );
      },
    ));
  }
}
