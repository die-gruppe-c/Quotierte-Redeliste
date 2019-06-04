import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/currently_speaking.dart';
import 'package:quotierte_redeliste/models/speaking_list_entry.dart';
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
  List<SpeakingListEntry> _usersSpeakingList;
  CurrentlySpeaking _currentlySpeaking;

  StreamSubscription _speakingListSubscription;
  StreamSubscription _currentlySpeakingSubscription;

  @override
  void initState() {
    super.initState();
    _usersSpeakingList = List();

    _speakingListSubscription = _webSocket
        .getSpeakingList()
        .listen((List<SpeakingListEntry> speakingList) {
      setState(() {
        _usersSpeakingList = speakingList;
      });
    });

    _currentlySpeakingSubscription = _webSocket
        .getCurrentlySpeaking()
        .listen((CurrentlySpeaking currentlySpeaking) {
      setState(() {
        _currentlySpeaking = currentlySpeaking;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_speakingListSubscription != null) _speakingListSubscription.cancel();

    if (_currentlySpeakingSubscription != null)
      _currentlySpeakingSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return _usersSpeakingList.length != 0 || _currentlySpeaking != null
        ? _getList(_usersSpeakingList)
        : Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Keine Redner")]));
  }

  Widget _getList(List<SpeakingListEntry> list) {
//    list.removeWhere((user) => user.id == "-1");

    return Expanded(
        child: ReorderableListView(
            header: _currentlySpeaking != null
                ? UserWidget(
                    widget.users.firstWhere((searchUser) =>
                        searchUser.id == _currentlySpeaking.speakerId),
                    highlight: true,
                  )
                : Container(),
            children: list.map((user) {
              return UserWidget(
                widget.users
                    .firstWhere((searchUser) => searchUser.id == user.id),
                key: Key(user.id),
                onTap: () {
                  _removeUserFromSpeakingList(user.id);
                },
              );
            }).toList(),
            onReorder: _listReordered));
  }

  _removeUserFromSpeakingList(String userId) {
    _webSocket.removeUserFromSpeakingList(userId);
  }

  _listReordered(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    _webSocket.changeOrderOfSpeakingList(
        _usersSpeakingList[oldIndex].id, newIndex);

    setState(() {
      final item = _usersSpeakingList.removeAt(oldIndex);
      _usersSpeakingList.insert(newIndex, item);
    });
  }
}
