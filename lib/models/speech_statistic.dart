class SpeechStatistic {
  String attributeName;
  int timeInMillis;
  Map<String, int> values;

  static List<SpeechStatistic> listFromJson(Map<String, dynamic> json) {
    List<SpeechStatistic> list = List();

    json.forEach((attribute, json) {
      SpeechStatistic statistic = SpeechStatistic();
      statistic.attributeName = attribute;
      statistic.timeInMillis = json["total"];
      statistic.values = Map<String, int>.from(json["values"]);

      list.add(statistic);
    });

    return list;
  }
}
