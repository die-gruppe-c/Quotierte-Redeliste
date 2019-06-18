class SpeechStatistic {
  String attributeName;
  Map<String, int> values;

  static List<SpeechStatistic> listFromJson(Map<String, dynamic> json) {
    List<SpeechStatistic> list = List();

    json.forEach((attribute, json) {
      SpeechStatistic statistic = SpeechStatistic();
      statistic.attributeName = attribute;
      statistic.values = Map<String, int>.from(json["values"]);

      list.add(statistic);
    });

    return list;
  }
}
