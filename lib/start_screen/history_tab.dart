import 'dart:async';

import 'package:flutter/material.dart';

class HistoryTab extends StatefulWidget {
  @override
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  Timer _timer;

  _HistoryTabState() {
    // TODO replace timer with load rooms from the backend
    _timer = Timer(Duration(seconds: 2), () {
      setState(() {
        _rooms = [
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
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  List<String> _rooms = [];

  @override
  Widget build(BuildContext context) {
    return Container(child: _rooms.isEmpty ? getEmptyState() : getListView());
  }

  Widget getEmptyState() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      CircularProgressIndicator(),
      Padding(padding: EdgeInsets.only(right: 20)),
      Text('Lade Daten...')
    ]);
  }

  Widget getListView() {
    return Column(children: [
      Expanded(
          child: ListView.builder(
        itemCount: _rooms.length,
        itemBuilder: (context, pos) {
          return getListViewItem(pos);
        },
      ))
    ]);
  }

  Widget getListViewItem(pos) {
    return Padding(
        padding: EdgeInsets.only(bottom: 2.0, left: 4, right: 4),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: Text(
              _rooms[pos],
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ));
  }
}
