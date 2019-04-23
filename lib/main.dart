// This sample shows adding an action to an [AppBar] that opens a shopping cart.

import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/ui/start_screen/start_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quoty',
      theme: ThemeData(
          primaryColor: Colors.white,
          primarySwatch: Colors.red,
          textTheme: TextTheme(
              display1: TextStyle(color: Colors.grey, fontSize: 20.0))),
      home: StartScreen(),
    );
  }
}
