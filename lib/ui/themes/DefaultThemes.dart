import 'package:flutter/material.dart';

class DefaultThemes {
  static InputDecoration inputDecoration(context, labelText) {
    return InputDecoration(
        border: OutlineInputBorder(),
        counterText: "",
        labelText: labelText,
        labelStyle:
            TextStyle(color: Theme.of(context).primaryColorDark, height: 0.5),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColorDark)));
  }
}
