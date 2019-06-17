import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/speaking_list_entry.dart';
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _webSocket.getUsersWantToSpeak(),
        builder:
            (context, AsyncSnapshot<List<SpeakingListEntry>> wantToSpeak) =>
                wantToSpeak.hasData && wantToSpeak.data.length != 0
                    ? _getList(wantToSpeak.data)
                    : _emptyState());
  }

  Widget _emptyState() => Expanded(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Keine Meldungen")]));

  Widget _getList(List<SpeakingListEntry> list) {
    List<User> wantToSpeakList = List();

    list.forEach((userWantToSpeak) {
      wantToSpeakList.add(widget.users.firstWhere((user) {
        return user.id == userWantToSpeak.id;
      }));
    });

    return Expanded(
        child: ListView.builder(
      controller: widget.scrollController,
      itemCount: list.length,
      itemBuilder: (context, pos) {
        return UserWidget(
          wantToSpeakList[pos],
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
