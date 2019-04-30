import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/user.dart';

class SpeakingList extends StatefulWidget {
  final List<User> users;

  SpeakingList(this.users, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SpeakingListState();
}

class _SpeakingListState extends State<SpeakingList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
