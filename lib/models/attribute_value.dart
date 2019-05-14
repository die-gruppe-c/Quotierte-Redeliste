import 'package:flutter/material.dart';

class AttributeValue {
  String value;
  Color color = Colors.black;
  int weight = 50;

  AttributeValue(this.value);

  AttributeValue.fromJson(json) {
    this.weight = json['weight'];
    this.color = _hexToColor(json['color']);
    this.value = json["name"];
  }

  AttributeValue.clone(AttributeValue attr) {
    value = attr.value;
    color = attr.color;
    weight = attr.weight;
  }

  /// Construct a color from a hex code string, of the format #RRGGBB.
  Color _hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  String _colorToHex(Color color) {
    return '#' + color.value.toRadixString(16).substring(2);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['name'] = value;
    map['color'] = _colorToHex(color);
    map['weight'] = weight;

    return map;
  }
}
