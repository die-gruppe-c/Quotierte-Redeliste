import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/user.dart';

class WantToSpeakList extends StatefulWidget {
  final List<User> users;

  WantToSpeakList(this.users, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WantToSpeakListState();
}

class _WantToSpeakListState extends State<WantToSpeakList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
