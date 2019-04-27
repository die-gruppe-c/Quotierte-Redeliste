import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EnterRoomScreen extends StatefulWidget {
  EnterRoomScreen({Key key}) : super(key: key);

  @override
  _EnterRoomScreenState createState() => new _EnterRoomScreenState();
}

class _EnterRoomScreenState extends State<EnterRoomScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _genders = <String>['', 'Männlich', 'Weiblich', 'Diverse'];
  List<String> _partys = <String>['', 'SPD', 'FDP', 'AFD', 'CDU'];
  String _gender = 'Männlich';
  String _party = 'CDU';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
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
}

class SaveFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        icon: Icon(Icons.save),
        onPressed: () => {},
        label: new Text('Speichern'));
  }
}
