import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quotierte_redeliste/models/room.dart';
import 'package:quotierte_redeliste/resources/repository.dart';

class HistoryTab extends StatefulWidget {
  @override
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  List<Room> _rooms;
  bool error;

  void _loadRooms() {
    setState(() {
      error = false;
    });

    Repository().getAllRooms().then((rooms) {
      setState(() {
        _rooms = rooms;
      });
    }).catchError((error) {
      print("Error when getting rooms: " + error.toString());
      setState(() {
        this.error = true;
      });
    });
  }

  void initState() {
    super.initState();
    _loadRooms();
  }

  @override
  Widget build(BuildContext context) {
    return error == true
        ? getErrorWidget()
        : _rooms == null ? getEmptyState() : getListView();
  }

  Widget getEmptyState() {
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          CircularProgressIndicator(),
          Padding(padding: EdgeInsets.only(top: 25)),
          Text('Räume werden geladen')
        ]));
  }

  Widget getErrorWidget() {
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text("Konnte die Räume nicht laden"),
          Padding(padding: EdgeInsets.only(top: 25)),
          RaisedButton(child: Text("Erneut versuchen"), onPressed: _loadRooms)
        ]));
  }

  Widget getListView() {
    return _rooms.isEmpty
        ? noDataAvailable()
        : Padding(
            padding: EdgeInsets.only(bottom: 80),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _rooms.length,
              itemBuilder: (context, pos) {
                return getListViewItem(pos);
              },
            ));
  }

  Widget noDataAvailable() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('Kein Räume gefunden.')]))
    ]);
  }

  Widget getListViewItem(pos) {
    return Card(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0),
      elevation: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              leading: Icon(MdiIcons.forum),
              title: Text('Raum: ' +
                  _rooms[pos].name +
                  ' (ID: ' +
                  _rooms[pos].id.toString() +
                  ')'),
              subtitle: Text('Erstellt am ' +
                  _rooms[pos].createOn.day.toString() +
                  '.' +
                  _rooms[pos].createOn.month.toString() +
                  '.' +
                  _rooms[pos].createOn.year.toString())),
        ],
      ),
    );
  }
}
