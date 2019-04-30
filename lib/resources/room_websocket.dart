import 'dart:async';
import 'dart:core';

import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:web_socket_channel/io.dart';

class RoomWebSocket {
  static const BASE_URL = "ws://" + Repository.BASE_URL;

  IOWebSocketChannel _webSocket;

  StreamController<List<User>> _streamAllUsers = StreamController<List<User>>();
  StreamController<List<String>> _streamAllUsersSorted =
      StreamController<List<String>>();
  StreamController<List<String>> _streamWantToSpeak =
      StreamController<List<String>>();
  StreamController<List<String>> _streamSpeakCategories =
      StreamController<List<String>>();

  connect() {
    _webSocket = IOWebSocketChannel.connect(BASE_URL);

    _webSocket.stream.listen((data) {
      // TODO read data and fill streams
    });
  }

  close() {
    _webSocket.sink.close();

    _streamAllUsers.close();
    _streamAllUsersSorted.close();
    _streamWantToSpeak.close();
    _streamSpeakCategories.close();
  }

  Stream<List<User>> getAllUsers() {
    return _streamAllUsers.stream;
  }

  Stream<List<String>> getSpeakCategories() {
    return _streamSpeakCategories.stream;
  }

  Stream<List<String>> getAllUsersSorted() {
    return _streamAllUsersSorted.stream;
  }

  Stream<List<String>> getUsersWantToSpeak() {
    return _streamWantToSpeak.stream;
  }

  wantToSpeak(String category) {
    String data = ""; // TODO fill data
    _webSocket.sink.add(data);
  }

  doNotWantToSpeak() {
    String data = ""; // TODO fill data
    _webSocket.sink.add(data);
  }

  changeOrderOfSpeakingList(String userId, int newPosition) {
    String data = ""; // TODO fill data
    _webSocket.sink.add(data);
  }

  addUserToSpeakingList(String userId) {
    String data = ""; // TODO fill data
    _webSocket.sink.add(data);
  }
}
