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
      if (value.value != "") {
        values.add(AttributeValue.clone(value));
      }
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

    int weights = 0;
    this.values.forEach((attribute) => weights += attribute.weight);
    assert(weights == 100 || weights == 0);

    map['values'] = values;

    return map;
  }

  int getTotalWeights(){
    int total = 0;

    for(var value in values){
      if(value.value == '') continue;
      total += value.weight;
    }

    return total;
  }

  void addWeights(){
    if(values.length < 2 || getTotalWeights() != 0) return;

    int eachWeight = 100 ~/ (this.values.length - 1);

    int rest = 100 % (this.values.length - 1);

    for(var value in values){
      if(value.value == '') continue;
      value.weight = eachWeight;
    }

    values[0].weight += rest;
  }

  void setWeight(int weight, int valueIdx) {

    if(weight > 100) weight = 100;

    this.values[valueIdx].weight = weight;

    int total = getTotalWeights();

    if(total == 100){
      return;
    }

    int diff = total - 100;

    //two because one is empty and one is the one that gets currently changed
    int eachLess = diff ~/ (this.values.length - 2);

    int rest = diff % (this.values.length - 2);

    if(diff < 0){
      rest = -rest;
    }

    int totalReduce = rest;

    for(int i = 0; i < values.length; i++){
      if(i == valueIdx) continue;

      totalReduce += eachLess;

      if(values[i].weight >= totalReduce){
        values[i].weight -= totalReduce;
        totalReduce = 0;
      }else{
        values[i].weight = 0;
        totalReduce -= values[i].weight;
      }
    }

  }
}
