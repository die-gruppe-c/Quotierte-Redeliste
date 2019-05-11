import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/room.dart';
import 'package:quotierte_redeliste/resources/repository.dart';

class EnterRoomScreen extends StatefulWidget {
  final String roomId;

  EnterRoomScreen(this.roomId, {Key key}) : super(key: key);

  @override
  _EnterRoomScreenState createState() => _EnterRoomScreenState();
}

class _EnterRoomScreenState extends State<EnterRoomScreen> {
  Room _room;
  bool _loading = true;
  List<String> selectedAttributes;

  void initState() {
    super.initState();
    Repository().getRoom(int.parse(widget.roomId)).then((room) {
      setState(() {
        _room = room;
        _loading = false;
        selectedAttributes = _room.attributes.map((attr) {
          return attr.values[0].value;
        }).toList();
      });
    }).catchError((error) {
      print(error.toString());
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Raum"),
      ),
      body: _loading ? _getLoadingIndicator() : getAttributeView(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _room != null ? setFloatingActionButton() : null,
    );
  }

  Widget _getLoadingIndicator() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CircularProgressIndicator(),
                Padding(padding: EdgeInsets.only(right: 20)),
                Text('Lade Daten...')
              ]),
        ]);
  }

  Widget getAttributeView() {
    return _room == null
        ? noValidRoom()
        : Column(children: [
            Expanded(
                child: ListView.builder(
              itemCount: _room.attributes.length,
              itemBuilder: (context, pos) {
                return getListViewItem(pos);
              },
            )),
          ]);
  }

  Widget noValidRoom() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/page_not_found_su7k.png',
            height: 250,
            width: 250,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 25),
          ),
          Text('Kein Beitritt in Raum möglich.',
              style: Theme.of(context).textTheme.display1),
        ]);
  }

  Widget getListViewItem(pos) {
    return Padding(
        padding: EdgeInsets.only(bottom: 2.0, left: 4, right: 4),
        child: _getDropdown(
            pos,
            _room.attributes[pos].name,
            _room.attributes[pos].values.map((attr) {
              return attr.value;
            }).toList()));
  }

  Widget setFloatingActionButton() {
    return FloatingActionButton.extended(
        icon: Icon(Icons.save),
        onPressed: () => {},
        label: new Text('Speichern'));
  }

  Widget _getDropdown(int pos, String name, List<String> values) {
    return new Form(
        autovalidate: true,
        child: new Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: new FormField(builder: (FormFieldState state) {
              return InputDecorator(
                decoration: InputDecoration(
                  labelText: name,
                ),
                child: new DropdownButtonHideUnderline(
                  child: new DropdownButton(
                    value: selectedAttributes[pos],
                    isDense: true,
                    items: values.map((String value) {
                      return new DropdownMenuItem(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedAttributes[pos] = newValue;
                      });
                    },
                  ),
                ),
              );
            })));
  }
}