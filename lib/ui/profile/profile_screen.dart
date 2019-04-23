import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/ui/profile/profile.dart';

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
  }

  String _username = "";
  TextEditingController _usernameController;

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
      body: Column(
        children: [
          Padding(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 30),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text("Name: "),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                      ),
                      Flexible(
                          child: TextField(
                        decoration:
                            InputDecoration(contentPadding: EdgeInsets.all(3)),
                        controller: _usernameController,
                      )),
                    ])
                  ])),
        ], // Children
      ),
    );
  }
}
