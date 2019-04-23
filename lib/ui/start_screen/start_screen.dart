import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/ui/create_room/create_room_screen.dart';
import 'package:quotierte_redeliste/ui/moderator_screen/moderator_screen.dart';
import 'package:quotierte_redeliste/ui/profile/profile_screen.dart';
import 'package:quotierte_redeliste/ui/start_screen/enter_new_room_tab.dart';
import 'package:quotierte_redeliste/ui/start_screen/history_tab.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: setAppbar(context),
          // body is the majority of the screen.
          body: TabBarView(children: [EnterNewRoomTab(), HistoryTab()]),
          floatingActionButton: setFloatingActionButton(context),
        ));
  }

  Widget setAppbar(context) {
    return AppBar(
      title: Text('Quoty'),
      bottom: TabBar(
        tabs: [
          Tab(text: 'Raum beitreten'),
          Tab(text: 'Verlauf'),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.account_circle),
          tooltip: 'Profil bearbeiten',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
        ),
        // TODO remove only for testing
        IconButton(
          icon: Icon(Icons.question_answer),
          tooltip: 'Moderator ansicht',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ModeratorScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget setFloatingActionButton(context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateRoomScreen()),
          ),
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
    );
  }
}
