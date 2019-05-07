import 'package:flutter/material.dart';

class ClientScreen extends StatefulWidget {
  ClientScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: setAppbar(context),
          // body is the majority of the screen.

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
      actions: <Widget>[],
    );
  }

  Widget setFloatingActionButton(context) {
    return FloatingActionButton(child: Icon(Icons.add), onPressed: () {});
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}
