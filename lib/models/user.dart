class User {
  String id;
  String name;
  Map<String, String> attributes;
  bool createdByOwner = true;
  bool online = false;

  User();

  User.fromJson(Map<String, dynamic> json) {
    this.id = json['uuid'];
    this.name = json['name'];

    this.createdByOwner = json['createdByOwner'];
    this.online = json['online'];

    this.attributes = Map<String, String>();

    if (json['attributes'] != null) {
      List attributes = json['attributes'];
      print(attributes.toString());
      attributes.forEach((attrJson) {
        this.attributes[attrJson["name"]] = attrJson["values"][0]["name"];
      });
    }
  }
}
