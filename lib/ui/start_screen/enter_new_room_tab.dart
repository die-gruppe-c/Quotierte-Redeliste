import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/enter_room_screen.dart';

class EnterNewRoomTab extends StatelessWidget {
  EnterNewRoomTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 26),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Frage den Moderator eines Raumes nach dem Beitritts-Code '
                    'und gebe ihn hier ein',
                    style: Theme.of(context).textTheme.display1),
                Padding(
                  padding: EdgeInsets.only(bottom: 25),
                ),
                Row(children: [
                  Flexible(
                      child: TextField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(3),
                              labelText: 'Raum Code eingeben'),
                          onSubmitted: (code) {
                            // TODO ...
                          })),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                  ),
                  RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EnterRoomScreen()),
                        );
                      },
                      child: const Text('beitreten'))
                ]),
              ]),
        ),
        Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text('Neuen Raum erstellen',
                  style: Theme.of(context).textTheme.display1),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 100),
                  child: IconTheme(
                    data: IconThemeData(color: Colors.grey),
                    child: Icon(Icons.arrow_forward),
                  )),
            ])),
      ], // Children
    );
  }
}
