import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key key}) : super(key: key);

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
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(3)),
                              onSubmitted: (code) {
                                // TODO ...
                              })),
                    ])
                  ])),
        ], // Children
      ),
    );
  }
}
