import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      } else if (_enterRoomButtonDisabled) {
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
            builder: (context) => EnterRoomScreen(_roomCodeController.text)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 26),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/login_jdch.png',
                      height: 250,
                      width: 250,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 25),
                    ),
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
                              decoration: DefaultThemes.inputDecoration(
                                  context, 'Raum Code eingeben'),
                              controller: _roomCodeController,
                              onSubmitted: (code) {
                                _enterNewRoom(context);
                              })),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                      ),
                      RaisedButton(
                          onPressed: _enterRoomButtonDisabled
                              ? null
                              : () => _enterNewRoom(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.vpn_key,
                              ),
                              Text(
                                '   Beitreten', //Real Padding missing.
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    ]),
                    Padding(
                      padding: EdgeInsets.only(bottom: 100),
                    )
                  ]),
            )
          ], // Children
        ));
  }
}
