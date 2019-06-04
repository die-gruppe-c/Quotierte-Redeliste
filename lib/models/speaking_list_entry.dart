class SpeakingListEntry {
  String id;
  String speechType;

  SpeakingListEntry.fromJson(json) {
    id = json['id'].toString();
    speechType = json['speechType'].toString();
  }
}
