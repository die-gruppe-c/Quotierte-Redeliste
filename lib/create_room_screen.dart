import 'package:flutter/material.dart';

class CreateRoomScreen extends StatelessWidget {
  CreateRoomScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Raum erstellen'),
        actions: <Widget>[
          // Add actions
        ],
      ),
      // body is the majority of the screen.
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // TODO add children
        ], // Children
      ),
    );
  }
}
