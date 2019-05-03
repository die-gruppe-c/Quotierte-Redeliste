import 'dart:async';
import 'dart:convert';

import 'package:quotierte_redeliste/models/profile.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

class RoomWebSocket {
  // Singleton pattern
  static final RoomWebSocket _singleton = RoomWebSocket._internal();

  factory RoomWebSocket() {
    return _singleton;
  }

  static const BASE_URL = "ws://" + Repository.BASE_URL;

  IOWebSocketChannel _webSocket;

  StreamController<List<User>> _streamAllUsers;
  StreamController<List<String>> _streamSpeakers;
  StreamController<List<String>> _streamSortedUsers;
  StreamController<List<String>> _streamWantToSpeak;
  StreamController<List<String>> _streamSpeakCategories;

  Observable<List<User>> _allUsersObservable;
  Observable<List<String>> _speakersObservable;
  Observable<List<String>> _sortedUsersObservable;
  Observable<List<String>> _wantToSpeakObservable;
  Observable<List<String>> _speakCategoriesObservable;

  RoomWebSocket._internal();

  _initStreamsAndObservables() {
    _streamAllUsers = StreamController<List<User>>.broadcast();
    _streamSpeakers = StreamController<List<String>>.broadcast();
    _streamSortedUsers = StreamController<List<String>>.broadcast();
    _streamWantToSpeak = StreamController<List<String>>.broadcast();
    _streamSpeakCategories = StreamController<List<String>>.broadcast();

    _allUsersObservable = Observable(_streamAllUsers.stream).shareValue();
    _speakersObservable = Observable(_streamSpeakers.stream).shareValue();
    _sortedUsersObservable = Observable(_streamSortedUsers.stream).shareValue();
    _wantToSpeakObservable = Observable(_streamWantToSpeak.stream).shareValue();
    _speakCategoriesObservable =
        Observable(_streamSpeakCategories.stream).shareValue();

    // listen to the observables to save the last value
    _allUsersObservable.listen((data) {});
    _speakersObservable.listen((data) {});
    _sortedUsersObservable.listen((data) {});
    _wantToSpeakObservable.listen((data) {});
    _speakCategoriesObservable.listen((data) {});
  }

  connect() {
    _initStreamsAndObservables();

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

//    Timer(Duration(seconds: 2), () {
//      List<User> users = List();
//      for (int i = 0; i < 30; i++) {
//        User user = User();
//        user.name = "Test name" + i.toString();
//        user.id = i.toString();
//        users.add(user);
//      }
//
//      print("send all users");
//      _streamAllUsers.add(users);
//
//      print("send sorted users");
//      List<String> usersId = List();
//      for (int i = 29; i >= 0; i--) {
//        usersId.add(i.toString());
//      }
//
//      _usersSorted(usersId);
//    });
//
//    Timer(Duration(seconds: 3), () {
//      List<String> speak = ["1", "2"];
//      print("send speaking list: " + speak.toString());
//
//      _speakingList(speak);
//    });
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

  close() {
    _webSocket.sink.close();

    _streamAllUsers.close();
    _streamSpeakers.close();
    _streamSortedUsers.close();
    _streamWantToSpeak.close();
    _streamSpeakCategories.close();
  }

  Stream<List<User>> getAllUsers() {
    return _allUsersObservable;
  }

  Stream<List<String>> getSpeakingList() {
    return _speakersObservable;
  }

  Stream<List<String>> getSpeakCategories() {
    return _speakCategoriesObservable;
  }

  Stream<List<String>> getAllUsersSorted() {
    return _sortedUsersObservable;
  }

  Stream<List<String>> getUsersWantToSpeak() {
    return _wantToSpeakObservable;
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
