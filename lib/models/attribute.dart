class Attribute{

  String name;
  List<String> values;

  Attribute(this.name){
    values = new List();
  }

  Attribute.clone(Attribute attribute){
    name = attribute.name;

    values = new List();

    attribute.values.forEach((value) {
      if (value != "")
        values.add(value);
    });
  }

  Attribute.fromJsonObject(attributeJson){
    this.name = attributeJson['name'];

    List<String> tempValues = [];
    for (int i = 0; i < attributeJson['values'].length; i++) {
      String value = attributeJson['values'][i];
      tempValues.add(value);
    }
    values = tempValues;
  }

}
