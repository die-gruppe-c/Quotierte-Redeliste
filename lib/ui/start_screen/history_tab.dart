import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/room.dart';
import 'package:quotierte_redeliste/resources/repository.dart';

class HistoryTab extends StatefulWidget {
  @override
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  List<Room> _rooms;

  void initState() {
    super.initState();
    Repository().getAllRooms().then((rooms) {
      setState(() {
        _rooms = rooms;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _rooms == null ? getEmptyState() : getListView());
  }

  Widget getEmptyState() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
          padding: EdgeInsets.only(top: 150),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            CircularProgressIndicator(),
            Padding(padding: EdgeInsets.only(top: 25)),
            Text('Räume werden geladen')
          ]))
    ]);
  }

  Widget getListView() {
    return _rooms.isEmpty
        ? noDataAvailable()
        : Column(children: [
            Expanded(
                child: ListView.builder(
              itemCount: _rooms.length,
              itemBuilder: (context, pos) {
                return getListViewItem(pos);
              },
            ))
          ]);
  }

  Widget noDataAvailable() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
          padding: EdgeInsets.only(top: 150),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('Kein Räume gefunden.')]))
    ]);
  }

  Widget getListViewItem(pos) {
    return Padding(
        padding: EdgeInsets.only(bottom: 2.0, left: 4, right: 4),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: Text(
              _rooms[pos].name,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ));
  }
}
