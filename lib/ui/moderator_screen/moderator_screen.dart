import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/all_users_list.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/speaking_list.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/want_to_speak_list.dart';

class ModeratorScreen extends StatefulWidget {
  @override
  _ModeratorScreenState createState() => _ModeratorScreenState();
}

class _ModeratorScreenState extends State<ModeratorScreen> {
  String roomName = "Test";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(roomName),
          automaticallyImplyLeading: false,
        ),
        body: Row(
          children: [
            AllUsersList(),
            SpeakingList(),
            WantToSpeakList(),
          ],
        ));
  }
}
