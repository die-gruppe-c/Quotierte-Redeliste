class CurrentlySpeaking {
  String speakerId;
  String speechTypeId;
  bool running;
  int duration;

  CurrentlySpeaking.fromJson(json) {
    print("Currently speaking from json: " + json.toString());
    this.speakerId = json['speaker'];
    this.speechTypeId = json['speechType'].toString();
    this.running = json['running'];
    this.duration = json['duration'];
  }
}
