import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/profile.dart';
import 'package:quotierte_redeliste/models/room.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/ui/themes/DefaultThemes.dart';
import 'package:quotierte_redeliste/ui/waiting_room/waiting_room_screen.dart';

class EnterRoomScreen extends StatefulWidget {
  final String roomId;
  final Room room;
  final bool forOtherUser;

  EnterRoomScreen(this.roomId, {this.forOtherUser = false, this.room, Key key})
      : super(key: key);

  @override
  _EnterRoomScreenState createState() => _EnterRoomScreenState();
}

class _EnterRoomScreenState extends State<EnterRoomScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Room _room;
  bool _loading = true;
  String loadingString = "Lade Daten...";
  String errorMessage;
  List<String> selectedAttributes;

  TextEditingController nameController;

  void initState() {
    super.initState();

    if (widget.forOtherUser != true) {
      Profile().getUsername().then((username) {
        print("username: " + username);
        nameController = TextEditingController(text: username);
        nameController.addListener(() => setState(() {}));
      });
    } else {
      nameController = TextEditingController();
      nameController.addListener(() => setState(() {}));
    }

    if (widget.room == null) {
      _loadRoomData();
    } else {
      _setRoomAsState(widget.room);
    }
  }

  _loadRoomData() {
    setState(() {
      _loading = true;
    });

    Repository().getRoom(int.parse(widget.roomId)).then((room) {
      setState(() {
        _setRoomAsState(room);
      });
    }).catchError((error) {
      print(error.toString());
      setState(() {
        _loading = false;
        errorMessage = error.toString();
      });
    });
  }

  _setRoomAsState(Room room) {
    _loading = false;
    _room = room;
    selectedAttributes = room.attributes.map((attr) {
      return attr.values[0].value;
    }).toList();
  }

  _sendData() {
    setState(() {
      _loading = true;
      loadingString = "Sende Daten...";
    });

    Map<String, String> attributes = Map();
    for (int i = 0; i < _room.attributes.length; i++) {
      attributes[_room.attributes[i].name] = selectedAttributes[i];
    }

    String uuid;
    if (widget.forOtherUser) {
      uuid = Profile.generateToken();
    }

    Repository()
        .joinRoom(_room.id.toString(), nameController.text, attributes,
            uuid: uuid)
        .then((_) {
      if (widget.forOtherUser) {
        Navigator.pop(context, true);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WaitingRoomScreen()),
        );
      }
    }, onError: (error) {
      _showError(error.toString());
    });
  }

  _showError(String error) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 6),
      content: Row(
        children: <Widget>[
          Icon(Icons.error),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(left: 8),
            child: Text(error),
          ))
        ],
      ),
    );

    _scaffoldKey.currentState..removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snackBar);

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Attribute auswählen"),
      ),
      body: _loading ? _getLoadingIndicator() : getAttributeView(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          _room != null && _loading == false ? setFloatingActionButton() : null,
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
                Text(loadingString)
              ]),
        ]);
  }

  Widget getAttributeView() {
    return _room == null
        ? noValidRoom()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                    child: TextField(
                      controller: nameController,
                      decoration:
                          DefaultThemes.inputDecoration(context, "Name"),
                    )),
                Expanded(
                    child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 60),
                  itemCount: _room.attributes.length,
                  itemBuilder: (context, pos) {
                    return getListViewItem(pos);
                  },
                )),
              ]);
  }

  Widget noValidRoom() {
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Text(
            'Kein Beitritt in Raum möglich. \n\n' + errorMessage,
            textAlign: TextAlign.center,
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          RaisedButton(
            child: Text("Erneut versuchen"),
            onPressed: _loadRoomData,
          )
        ]));
  }

  Widget getListViewItem(pos) {
    return Padding(
        padding: EdgeInsets.only(top: 0, bottom: 20.0, left: 5, right: 5),
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
        backgroundColor:
            nameController.text != "" ? null : Theme.of(context).disabledColor,
        onPressed: nameController.text != "" ? _sendData : null,
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
