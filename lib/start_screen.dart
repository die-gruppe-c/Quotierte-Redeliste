import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/create_room_screen.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> rooms = [
      "raum 1",
      "raum 2",
      "raum test",
      "raum test 2",
      "noch ein raum",
      "oh yeah ein raum",
      "und noch einer",
      "einer mit einem ewig langen so laaaaangem text, dass er wahrscheinlich nicht mehr in die Liste passt",
      "gaaaaanz viele räume",
      "Oh ja",
      "Noch mehr Räume",
      "3",
      "2",
      "1",
      "GAME OVER"
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quoty'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            tooltip: 'Profil bearbeiten',
            onPressed: () {
              // TODO ...
            },
          ),
        ],
      ),
      // body is the majority of the screen.
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Code zum Beitreten eingeben'),
          Row(children: [
            TextField(onSubmitted: (code) {
              // TODO ...
            }),
            RaisedButton(
                onPressed: () {
                  // TODO ...
                },
                child: const Text('beitreten'))
          ]),
          Text('Oder'),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateRoomScreen()),
              );
            },
            child: const Text('+ neuen Raum erstellen'),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, pos) {
              return Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      child: Text(
                        rooms[pos],
                        style: TextStyle(
                          fontSize: 18.0,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ));
            },
          ))
        ], // Children
      ),
    );
  }
}
