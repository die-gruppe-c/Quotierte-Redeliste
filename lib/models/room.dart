import 'package:quotierte_redeliste/models/attribute.dart';

class Room {
  int id;
  String name;
  String owner;
  DateTime createOn;
  bool archived;
  bool running;

  List<Attribute> attributes;

  Room() {
    attributes = new List();
  }

  Room.clone(Room room) {
    id = room.id;
    name = room.name;
    createOn = room.createOn;
    archived = room.archived;
    running = room.running;
    owner = room.owner;

    attributes = new List();

    room.attributes.forEach((attribute) {
      if (attribute.name != "") attributes.add(Attribute.clone(attribute));
    });
  }

  Room.fromJson(Map<String, dynamic> parsedJson) {
    print("parse room: " + parsedJson.toString());
    this.id = parsedJson['id'];
    this.name = parsedJson['name'];
    this.owner = parsedJson['owner'];
    this.archived = parsedJson['archived'];
    this.running = parsedJson['running'];

    if (parsedJson['created_on'] != null)
      this.createOn = DateTime.parse(parsedJson['created_on']);

    List<Attribute> tempAttributes = [];
    if (parsedJson['attributes'] != null) {
      for (int i = 0; i < parsedJson['attributes'].length; i++) {
        Attribute attribute =
            Attribute.fromJsonObject(parsedJson['attributes'][i]);
        tempAttributes.add(attribute);
      }
    }
    attributes = tempAttributes;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = this.name;
    map["attributes"] =
        this.attributes.map((attribute) => attribute.toMap()).toList();

    return map;
  }
}
