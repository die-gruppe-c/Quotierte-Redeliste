import 'package:flutter/material.dart';

class AttributeValue {
  String value;
  Color color;
  int weight;

  AttributeValue(this.value);

  AttributeValue.fromJson(json) {
    print("attribute value: " + json.toString());
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
}
