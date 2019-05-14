import 'dart:async';
import 'dart:convert';

import 'package:quotierte_redeliste/models/profile.dart';
import 'package:quotierte_redeliste/models/speaking_category.dart';
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

  _ObservableStream<List<User>> _streamAllUsers;
  _ObservableStream<List<String>> _streamSpeakers;
  _ObservableStream<List<String>> _streamSortedUsers;
  _ObservableStream<List<String>> _streamWantToSpeak;
  _ObservableStream<List<SpeakingCategory>> _streamSpeakCategories;
  _ObservableStream<RoomState> _streamRoomState;

  bool _closed = true;

  RoomWebSocket._internal();

  _initStreams() {
    // close all connections that where opened before
    if (!_closed) close();

    _streamAllUsers = _ObservableStream();
    _streamSpeakers = _ObservableStream();
    _streamSortedUsers = _ObservableStream();
    _streamWantToSpeak = _ObservableStream();
    _streamSpeakCategories = _ObservableStream();
    _streamRoomState = _ObservableStream();
  }

  /// call this only once
  connect() {
    print("Websocket connect");

    _initStreams();

    _webSocket = IOWebSocketChannel.connect(BASE_URL);
    _closed = false;

    print("Websocket connected");

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
    }, onDone: _onClosed, onError: _onError);

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

  _speakCategories(Map<String, String> categories) {
    List<SpeakingCategory> newSpeakingCategories = List();

    categories.forEach((key, value) =>
        newSpeakingCategories.add(SpeakingCategory(key, value)));

    _streamSpeakCategories.add(newSpeakingCategories);
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

  _onClosed() {
    _streamRoomState.add(RoomState.DISCONNECTED);
    close();
  }

  _onError(error) {
    this._errorMessage = error.toString();
    _streamRoomState.add(RoomState.ERROR);
    close();
  }

  close() {
    _webSocket.sink.close();

    _streamAllUsers.close();
    _streamSpeakers.close();
    _streamSortedUsers.close();
    _streamWantToSpeak.close();
    _streamSpeakCategories.close();

    _closed = true;
  }

  Stream<List<User>> getAllUsers() {
    return _streamAllUsers.getStream();
  }

  Stream<List<String>> getSpeakingList() {
    return _streamSpeakers.getStream();
  }

  Stream<List<SpeakingCategory>> getSpeakCategories() {
    return _streamSpeakCategories.getStream();
  }

  Stream<List<String>> getAllUsersSorted() {
    return _streamSortedUsers.getStream();
  }

  Stream<List<String>> getUsersWantToSpeak() {
    return _streamWantToSpeak.getStream();
  }

  wantToSpeak(SpeakingCategory category) {
    String data = _WebSocketCommands.WANT_TO_SPEAK + ":" + category.id;
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
    String data =
        _WebSocketCommands.REMOVE_USER_FROM_SPEAKING_LIST + ":" + userId;
    _webSocket.sink.add(data);
  }

  start() {
    String data = _WebSocketCommands.START;
    _webSocket.sink.add(data);
  }
}

enum RoomState { STARTED, DISCONNECTED, ERROR }

class _WebSocketCommands {
  // receive

  // only moderator
  static const USERS_SORTED = "usersSorted";
  static const USERS_WANT_TO_SPEAK = "usersWantToSpeak";

  static const SPEAKING_LIST = "speakingList";
  static const STARTED = "started";
  static const ALL_USERS = "allUsers";
  static const SPEAK_CATEGORIES = "speechTypes";

  // send

  // only moderator
//  static const UPDATE_USER_LIST = "updateUserList"; only for testing
  static const START = "start";
  static const CHANGE_ORDER_SPEAKING_LIST = "changeSortOrder";
  static const ADD_USER_TO_SPEAKING_LIST = "addUserToSpeechList";
  static const REMOVE_USER_FROM_SPEAKING_LIST = "removeUserFromSpeechList";

  static const REGISTER = "register";
  static const WANT_TO_SPEAK = "wantToSpeak";
  static const WANT_NOT_TO_SPEAK = "wantNotToSpeak";
}
