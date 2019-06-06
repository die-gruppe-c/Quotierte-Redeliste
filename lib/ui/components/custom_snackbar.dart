import 'package:flutter/material.dart';

///
/// Class to show content in a snackbar.
/// Use the scaffoldKey as the key in your scaffold in your screen
class CustomSnackbar {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  showError(String error) {
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

    scaffoldKey.currentState..removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
