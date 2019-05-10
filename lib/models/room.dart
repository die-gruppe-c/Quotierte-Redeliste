import 'package:quotierte_redeliste/models/attribute.dart';

class Room {
  int id;
  String name;
  DateTime createOn;
  List<Attribute> attributes;

  Room() {
    attributes = new List();
  }

  Room.clone(Room room) {
    id = room.id;
    name = room.name;
    createOn = room.createOn;

    attributes = new List();

    room.attributes.forEach((attribute) {
      if (attribute.name != "") attributes.add(Attribute.clone(attribute));
    });
  }

  Room.fromJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['id'];
    this.name = parsedJson['name'];

    if (parsedJson['created_on'] != null)
      this.createOn = DateTime.parse(parsedJson['created_on']);

    List<Attribute> tempAttributes = [];
    for (int i = 0; i < parsedJson['attributes'].length; i++) {
      Attribute attribute =
          Attribute.fromJsonObject(parsedJson['attributes'][i]);
      tempAttributes.add(attribute);
    }
    attributes = tempAttributes;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = this.name;

    return map;
  }
}
