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

  List<String> _genders = <String>['', 'Männlich', 'Weiblich', 'Diverse'];
  List<String> _partys = <String>['', 'SPD', 'FDP', 'AFD', 'CDU'];
  String _gender = 'Männlich';
  String _party = 'CDU';

  void initState() {
    super.initState();
    Repository().getRoom(1).then((room) {
      setState(() {
        _room = room;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return getAttributeView();
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
            setFloatingActionButton(),
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
          Text('Kein Beitritt in Raum' + _room.name + 'möglich.',
              style: Theme.of(context).textTheme.display1),
        ]);
  }

  Widget getListViewItem(pos) {
    return Padding(
        padding: EdgeInsets.only(bottom: 2.0, left: 4, right: 4),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: Text(
              _room.name,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ));
  }

  Widget setFloatingActionButton() {
    return FloatingActionButton.extended(
        icon: Icon(Icons.save),
        onPressed: () => {},
        label: new Text('Speichern'));
  }
}

/*
return Scaffold(
appBar: AppBar(
title: Text('Attribute setzen'),
actions: <Widget>[
// Add actions
],
),
// body is the majority of the screen.
body: new SafeArea(
top: false,
bottom: false,
child: new Form(
key: _formKey,
autovalidate: true,
child: new ListView(
padding: const EdgeInsets.symmetric(horizontal: 16.0),
children: <Widget>[
new FormField(
builder: (FormFieldState state) {
return InputDecorator(
decoration: InputDecoration(
icon: const Icon(MdiIcons.humanMaleFemale),
labelText: 'Geschlecht',
),
isEmpty: _gender == '',
child: new DropdownButtonHideUnderline(
child: new DropdownButton(
value: _gender,
isDense: true,
onChanged: (String newValue) {
setState(() {
_gender = newValue;
state.didChange(newValue);
});
},
items: _genders.map((String value) {
return new DropdownMenuItem(
value: value,
child: new Text(value),
);
}).toList(),
),
),
);
},
),
new FormField(
builder: (FormFieldState state) {
return InputDecorator(
decoration: InputDecoration(
icon: Icon(MdiIcons.accountGroup),
labelText: 'Parteizugehörigkeit',
),
isEmpty: _party == '',
child: new DropdownButtonHideUnderline(
child: new DropdownButton(
value: _party,
isDense: true,
onChanged: (String newValue) {
setState(() {
_party = newValue;
state.didChange(newValue);
});
},
items: _partys.map((String value) {
return new DropdownMenuItem(
value: value,
child: new Text(value),
);
}).toList(),
),
),
);
},
),
],
))),
floatingActionButton: SaveFAB(),
floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
}
*/
