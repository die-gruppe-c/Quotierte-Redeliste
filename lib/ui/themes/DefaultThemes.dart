import 'package:flutter/material.dart';

class DefaultThemes {
  static InputDecoration inputDecoration(context, labelText) {
    return InputDecoration(
        contentPadding: EdgeInsets.only(left: 0, right: 3, top: 0, bottom: 5),
        labelText: labelText,
        labelStyle:
            TextStyle(color: Theme.of(context).primaryColorDark, height: 0.5),
        focusedBorder: UnderlineInputBorder(
            borderSide: new BorderSide(color: Theme.of(context).accentColor)));
  }
}
