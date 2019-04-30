class User {
  String id;
  String name;
  Map<String, String> attributes;
  bool createdByModerator = false;

  User.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];

    if (json['createdByModerator'] != null)
      this.createdByModerator = json['createdByModerator'];

    this.attributes = Map<String, String>();

    if (json['attributes']) {
      List attributes = json['attributes'];
      attributes.forEach((attrJson) {
        this.attributes[attrJson["name"]] = attrJson["value"];
      });
    }
  }
}
