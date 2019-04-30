import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:quotierte_redeliste/models/profile.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:web_socket_channel/io.dart';

class RoomWebSocket {
  static const BASE_URL = "ws://" + Repository.BASE_URL;

  IOWebSocketChannel _webSocket;

  StreamController<List<User>> _streamAllUsers = StreamController<List<User>>();
  StreamController<List<String>> _streamNextSpeakers =
      StreamController<List<String>>();
  StreamController<List<String>> _streamAllUsersSorted =
      StreamController<List<String>>();
  StreamController<List<String>> _streamWantToSpeak =
      StreamController<List<String>>();
  StreamController<List<String>> _streamSpeakCategories =
      StreamController<List<String>>();

  connect() {
    _webSocket = IOWebSocketChannel.connect(BASE_URL);

    _webSocket.stream.listen((data) {
      Map<String, dynamic> parsedJson = json.decode(data);
      String command = parsedJson["command"];
      dynamic commandData = parsedJson["data"];
      switch (command) {
        case WebSocketCommands.ALL_USERS:
          _allUsers(commandData);
          break;
        case WebSocketCommands.SPEAKING_LIST:
          _speakingList(commandData);
          break;
        case WebSocketCommands.SPEAK_CATEGORIES:
          _speakCategories(commandData);
          break;
        case WebSocketCommands.USERS_SORTED:
          _usersSorted(commandData);
          break;
        case WebSocketCommands.USERS_WANT_TO_SPEAK:
          _usersWantToSpeak(commandData);
          break;
      }
    });

    _sendId();
  }

  _sendId() {
    Profile().getToken().then((token) {
      _webSocket.sink.add(WebSocketCommands.REGISTER + ":" + token);
    });
  }

  _allUsers(List commandData) {
    List<User> listUsers = List();
    commandData.forEach((userJson) {
      listUsers.add(User.fromJson(userJson));
    });

    _streamAllUsers.add(listUsers);
  }

  _speakingList(List<String> ids) {
    _streamNextSpeakers.add(ids);
  }

  _speakCategories(List<String> categories) {
    _streamSpeakCategories.add(categories);
  }

  _usersSorted(List<String> ids) {
    _streamAllUsersSorted.add(ids);
  }

  _usersWantToSpeak(List<String> ids) {
    _streamWantToSpeak.add(ids);
  }

  close() {
    _webSocket.sink.close();

    _streamAllUsers.close();
    _streamNextSpeakers.close();
    _streamAllUsersSorted.close();
    _streamWantToSpeak.close();
    _streamSpeakCategories.close();
  }

  Stream<List<User>> getAllUsers() {
    return _streamAllUsers.stream;
  }

  Stream<List<String>> getSpeakingList() {
    return _streamNextSpeakers.stream;
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
    String data = WebSocketCommands.WANT_TO_SPEAK + ":" + category;
    _webSocket.sink.add(data);
  }

  doNotWantToSpeak() {
    String data = WebSocketCommands.WANT_NOT_TO_SPEAK;
    _webSocket.sink.add(data);
  }

  changeOrderOfSpeakingList(String userId, int newPosition) {
    String data = WebSocketCommands.CHANGE_ORDER_SPEAKING_LIST +
        ":" +
        userId +
        "," +
        newPosition.toString();
    _webSocket.sink.add(data);
  }

  addUserToSpeakingList(String userId) {
    String data = WebSocketCommands.ADD_USER_TO_SPEAKING_LIST + ":" + userId;
    _webSocket.sink.add(data);
  }
}

class WebSocketCommands {
  // receive
  static const ALL_USERS = "allUsers";
  static const SPEAKING_LIST = "speakingList";
  static const SPEAK_CATEGORIES = "speakCategories";
  static const USERS_SORTED = "usersSorted";
  static const USERS_WANT_TO_SPEAK = "usersWantToSpeak";

  // send
  static const REGISTER = "register";
  static const WANT_TO_SPEAK = "wantToSpeak";
  static const WANT_NOT_TO_SPEAK = "wantNotToSpeak";
  static const CHANGE_ORDER_SPEAKING_LIST = "changeOrder";
  static const ADD_USER_TO_SPEAKING_LIST = "addUserToSpeakingList";
}
