import 'package:quotierte_redeliste/models/attribute_value.dart';

class Attribute {
  String name;
  List<AttributeValue> values;

  Attribute(this.name) {
    values = new List();
  }

  Attribute.clone(Attribute attribute) {
    name = attribute.name;

    values = new List();

    attribute.values.forEach((value) {
      values.add(AttributeValue.clone(value));
    });
  }

  Attribute.fromJsonObject(attributeJson) {
    this.name = attributeJson['name'];

    List<AttributeValue> tempValues = [];
    for (int i = 0; i < attributeJson['values'].length; i++) {
      AttributeValue value =
          AttributeValue.fromJson(attributeJson['values'][i]);
      tempValues.add(value);
    }
    values = tempValues;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['name'] = this.name;

    List<Map<String, dynamic>> values =
        this.values.map((attribute) => attribute.toMap()).toList();

    map['values'] = values;

    return map;
  }
}
