import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/ui/enter_room/enter_room_screen.dart';
import 'package:quotierte_redeliste/ui/themes/DefaultThemes.dart';

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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/login_jdch.png',
                  height: 125,
                  width: 125,
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
                      ))
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
                    data: IconThemeData(color: Theme.of(context).hintColor),
                    child: Icon(Icons.arrow_forward),
                  )),
            ])),
      ], // Children
    );
  }
}
