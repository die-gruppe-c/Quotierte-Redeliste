import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quotierte_redeliste/ui/enter_room/enter_room_screen.dart';
import 'package:quotierte_redeliste/ui/themes/DefaultThemes.dart';

class EnterNewRoomTab extends StatefulWidget {
  @override
  _EnterNewRoomState createState() => _EnterNewRoomState();
}

class _EnterNewRoomState extends State<EnterNewRoomTab> {
  bool _enterRoomButtonDisabled = true;
  TextEditingController _roomCodeController = TextEditingController();

  _EnterNewRoomState() {
    _roomCodeController.addListener(() {
      if (_roomCodeController.text == "") {
        setState(() {
          _enterRoomButtonDisabled = true;
        });
      } else if (_enterRoomButtonDisabled &&
          _roomCodeController.text.length == 4) {
        setState(() {
          _enterRoomButtonDisabled = false;
        });
      }
    });
  }

  _enterNewRoom(context) {
    if (_roomCodeController.text != "") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                new EnterRoomScreen(_roomCodeController.text)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
        child: Container(
          height: 60,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: TextField(
                        textAlign: TextAlign.center,
                        maxLength: 4,
                        keyboardType: TextInputType
                            .number, //TODO: Letters still possible trough copy/paste
                        decoration:
                            DefaultThemes.inputDecoration(context, "Raum ID"),
                        controller: _roomCodeController,
                        onSubmitted: (code) {
                          _enterNewRoom(context);
                        })),
                Padding(padding: EdgeInsets.only(left: 25)),
                Expanded(
                    child: RaisedButton.icon(
                  icon: Icon(
                    MdiIcons.key,
                  ),
                  color: Theme.of(context).accentColor,
                  textColor: Theme.of(context).accentTextTheme.button.color,
                  label: Text('BEITRETEN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: _enterRoomButtonDisabled
                      ? null
                      : () => _enterNewRoom(context),
                )),
              ]),
        ));
  }
}
