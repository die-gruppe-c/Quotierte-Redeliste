import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/models/profile.dart';
import 'package:quotierte_redeliste/ui/themes/DefaultThemes.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  _ProfileState() {
    Profile().getUsername().then((usr) => setState(() {
          _username = usr;
          _usernameController = TextEditingController(text: _username);
          _usernameController.addListener(_updateUsername);
        }));

    Profile().getToken().then((token) => setState(() {
          _token = token;
          _tokenController = TextEditingController(text: _token);
          _tokenController.addListener(() {
            Profile().setToken(_tokenController.text);
          });
        }));
  }

  String _username = "";
  String _token = "";
  TextEditingController _usernameController;
  TextEditingController _tokenController;

  _updateUsername() {
    Profile().setUsername(_usernameController.text);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profil'),
          actions: <Widget>[
            // Add actions
          ],
        ),
        // body is the majority of the screen.
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 30),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Flexible(
                              child: TextField(
                            decoration:
                                DefaultThemes.inputDecoration(context, "Name"),
                            controller: _usernameController,
                          )),
                        ]),
                        Padding(padding: EdgeInsets.only(top: 30)),
                        // TODO only for test purpose
                        Row(children: [
                          Flexible(
                              child: TextField(
                            decoration:
                                DefaultThemes.inputDecoration(context, "Token"),
                            controller: _tokenController,
                          )),
                        ])
                      ])),
            ], // Children
          ),
        ));
  }
}
