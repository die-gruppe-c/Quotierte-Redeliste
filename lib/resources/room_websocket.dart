import 'dart:async';
import 'dart:convert';

import 'package:quotierte_redeliste/models/profile.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

/// creates a broadcast stream and starts listening to it
/// when a user subscribes the stream from getStream() the
/// last value will be emitted at the time of the subscription
class _ObservableStream<T> {
  StreamController<T> _streamController;
  Observable<T> _observable;

  _ObservableStream() {
    _streamController = StreamController<T>.broadcast();
    _observable = Observable(_streamController.stream).shareValue();
    _observable.listen((data) {});
  }

  Stream<T> getStream() => _observable;

  add(T send) => _streamController.add(send);

  close() => _streamController.close();
}

class RoomWebSocket {
  // Singleton pattern
  static final RoomWebSocket _singleton = RoomWebSocket._internal();

  factory RoomWebSocket() {
    return _singleton;
  }

  static const BASE_URL = "ws://" + Repository.BASE_URL;

  IOWebSocketChannel _webSocket;

  _ObservableStream<List<User>> _streamAllUsers = _ObservableStream();
  _ObservableStream<List<String>> _streamSpeakers = _ObservableStream();
  _ObservableStream<List<String>> _streamSortedUsers = _ObservableStream();
  _ObservableStream<List<String>> _streamWantToSpeak = _ObservableStream();
  _ObservableStream<List<String>> _streamSpeakCategories = _ObservableStream();
  _ObservableStream<RoomState> _streamRoomState = _ObservableStream();

  RoomWebSocket._internal();

  connect() {
    _webSocket = IOWebSocketChannel.connect(BASE_URL);

    _webSocket.stream.listen((data) {
      Map<String, dynamic> parsedJson = json.decode(data);
      String command = parsedJson["command"];
      dynamic commandData = parsedJson["data"];

      print("Websocket command: " + command);
      print("Websocket data: " + commandData.toString());

      switch (command) {
        case _WebSocketCommands.ALL_USERS:
          _allUsers(commandData);
          break;
        case _WebSocketCommands.SPEAKING_LIST:
          _speakingList(commandData);
          break;
        case _WebSocketCommands.SPEAK_CATEGORIES:
          _speakCategories(commandData);
          break;
        case _WebSocketCommands.USERS_SORTED:
          _usersSorted(commandData);
          break;
        case _WebSocketCommands.USERS_WANT_TO_SPEAK:
          _usersWantToSpeak(commandData);
          break;
        case _WebSocketCommands.STARTED:
          _roomStarted();
          break;
      }
    });

    _sendId();
  }

  _sendId() {
    Profile().getToken().then((token) {
      _webSocket.sink.add(_WebSocketCommands.REGISTER + ":" + token);
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
    _streamSpeakers.add(ids);
  }

  _speakCategories(List<String> categories) {
    _streamSpeakCategories.add(categories);
  }

  _usersSorted(List<String> ids) {
    _streamSortedUsers.add(ids);
  }

  _usersWantToSpeak(List<String> ids) {
    _streamWantToSpeak.add(ids);
  }

  _roomStarted() {
    _streamRoomState.add(RoomState.STARTED);
  }

  close() {
    _webSocket.sink.close();

    _streamAllUsers.close();
    _streamSpeakers.close();
    _streamSortedUsers.close();
    _streamWantToSpeak.close();
    _streamSpeakCategories.close();
  }

  Stream<List<User>> getAllUsers() {
    return _streamAllUsers.getStream();
  }

  Stream<List<String>> getSpeakingList() {
    return _streamSpeakers.getStream();
  }

  Stream<List<String>> getSpeakCategories() {
    return _streamSpeakCategories.getStream();
  }

  Stream<List<String>> getAllUsersSorted() {
    return _streamSortedUsers.getStream();
  }

  Stream<List<String>> getUsersWantToSpeak() {
    return _streamWantToSpeak.getStream();
  }

  wantToSpeak(String category) {
    String data = _WebSocketCommands.WANT_TO_SPEAK + ":" + category;
    _webSocket.sink.add(data);
  }

  doNotWantToSpeak() {
    String data = _WebSocketCommands.WANT_NOT_TO_SPEAK;
    _webSocket.sink.add(data);
  }

  changeOrderOfSpeakingList(String userId, int newPosition) {
    String data = _WebSocketCommands.CHANGE_ORDER_SPEAKING_LIST +
        ":" +
        userId +
        "," +
        newPosition.toString();
    _webSocket.sink.add(data);
  }

  addUserToSpeakingList(String userId) {
    String data = _WebSocketCommands.ADD_USER_TO_SPEAKING_LIST + ":" + userId;
    _webSocket.sink.add(data);
  }

  removeUserFromSpeakingList(String userId) {
    // TODO implement
  }

  start() {
    String data = _WebSocketCommands.START;
    _webSocket.sink.add(data);
  }
}

enum RoomState { STARTED }

class _WebSocketCommands {
  // receive
  static const STARTED = "started";
  static const ALL_USERS = "allUsers";
  static const SPEAKING_LIST = "speakingList";
  static const SPEAK_CATEGORIES = "speechTypes";
  static const USERS_SORTED = "usersSorted";
  static const USERS_WANT_TO_SPEAK = "usersWantToSpeak";

  // send
  static const START = "start";
  static const REGISTER = "register";
  static const WANT_TO_SPEAK = "wantToSpeak";
  static const WANT_NOT_TO_SPEAK = "wantNotToSpeak";
  static const CHANGE_ORDER_SPEAKING_LIST = "changeSortOrder";
  static const ADD_USER_TO_SPEAKING_LIST = "addUserToSpeechList";
}
