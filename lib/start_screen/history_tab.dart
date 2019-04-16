import 'package:flutter/material.dart';

class HistoryTab extends StatelessWidget {
  HistoryTab({Key key}) : super(key: key);

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

    return Column(children: [
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
    ]);
  }
}
