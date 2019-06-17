import 'attribute.dart';

class User {
  // frontend_id only available when room started
  String id = "-1";

  // uuid only for own user available
  String _uuid;

  String name;

  List<Attribute> attributes;

  bool createdByOwner = true;
  bool online = false;

  User();

  bool isOwnUser() => _uuid != null && _uuid != "";

  User.fromJson(Map<String, dynamic> json) {
    this._uuid = json['uuid'];

    if (json['frontend_id'] != null) this.id = json['frontend_id'];

    this.name = json['name'];

    this.createdByOwner = json['createdByOwner'];
    this.online = json['online'];

    this.attributes = List();
    List attributes = json['attributes'];
    attributes.forEach((attrJson) {
      this.attributes.add(Attribute.fromJsonObject(attrJson));
    });
  }
}
