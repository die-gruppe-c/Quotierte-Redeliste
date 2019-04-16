import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/create_room_screen.dart';
import 'package:quotierte_redeliste/profile/profile_screen.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      // body is the majority of the screen.
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 30),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Raum beitreten',
                      style: Theme.of(context).textTheme.title),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                  ),
                  Row(children: [
                    Flexible(
                        child: TextField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(3),
                                labelText: 'Code zum Beitreten'),
                            onSubmitted: (code) {
                              // TODO ...
                            })),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                    ),
                    RaisedButton(
                        onPressed: () {
                          // TODO ...
                        },
                        child: const Text('beitreten'))
                  ]),
                  Padding(
                    padding: EdgeInsets.only(top: 25, bottom: 5),
                    child: Text('Raum erstellen',
                        style: Theme.of(context).textTheme.title),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateRoomScreen()),
                      );
                    },
                    child: const Text('+ neuen Raum erstellen'),
                  ),
                ]),
          ),
          Text('Historie', style: Theme.of(context).textTheme.title),
          Padding(padding: EdgeInsets.only(bottom: 8)),
          Expanded(
              child: ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, pos) {
              return Padding(
                  padding: EdgeInsets.only(bottom: 2.0, left: 4, right: 4),
                  child: Card(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                      child: Text(
                        rooms[pos],
                        style: TextStyle(
                          fontSize: 18.0,
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
