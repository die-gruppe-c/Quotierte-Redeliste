class User {
  // frontend_id only available when room started
  String id = "-1";

  // uuid only for own user available
  String _uuid;

  String name;

  // first string is the name of the attribute, second string is the value
  Map<String, String> attributes;

  bool createdByOwner = true;
  bool online = false;

  User();

  User.fromJson(Map<String, dynamic> json) {
    this._uuid = json['uuid'];

    if (json['frontend_id'] != null) this.id = json['frontend_id'];

    this.name = json['name'];

    this.createdByOwner = json['createdByOwner'];
    this.online = json['online'];

    this.attributes = Map<String, String>();
    List attributes = json['attributes'];
    print(attributes.toString());
    attributes.forEach((attrJson) {
      this.attributes[attrJson["name"]] = attrJson["values"][0]["name"];
    });
  }
}
