import 'dart:async';
import 'dart:convert';

import 'package:quotierte_redeliste/models/currently_speaking.dart';
import 'package:quotierte_redeliste/models/profile.dart';
import 'package:quotierte_redeliste/models/speaking_list_entry.dart';
import 'package:quotierte_redeliste/models/speech_statistic.dart';
import 'package:quotierte_redeliste/models/user.dart';
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

import '../models/room.dart';

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

  bool isOpen() => !_streamController.isClosed;

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
  _ObservableStream<List<SpeakingListEntry>> _streamSpeakers;
  _ObservableStream<List<String>> _streamSortedUsers;
  _ObservableStream<List<SpeakingListEntry>> _streamWantToSpeak;
  _ObservableStream<Room> _streamRoomData;
  _ObservableStream<RoomState> _streamRoomState;
  _ObservableStream<CurrentlySpeaking> _streamCurrentlySpeaking;
  _ObservableStream<List<SpeechStatistic>> _streamStatistics;
  _ObservableStream<bool>
      _streamWantToSpeakStatus; // true when the user is on the want to speak list otherwise false

  bool _closed = true;
  String _errorMessage;

  RoomWebSocket._internal();

  _initStreams() {
    // close all connections that where opened before
    if (!_closed) close();

    _streamAllUsers = _ObservableStream();
    _streamSpeakers = _ObservableStream();
    _streamSortedUsers = _ObservableStream();
    _streamWantToSpeak = _ObservableStream();
    _streamRoomState = _ObservableStream();
    _streamRoomData = _ObservableStream();
    _streamCurrentlySpeaking = _ObservableStream();
    _streamStatistics = _ObservableStream();
    _streamWantToSpeakStatus = _ObservableStream();
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
        case _WebSocketCommands.USERS_SORTED:
          _usersSorted(commandData);
          break;
        case _WebSocketCommands.USERS_WANT_TO_SPEAK:
          _usersWantToSpeak(commandData);
          break;
        case _WebSocketCommands.STARTED:
          _roomStarted();
          break;
        case _WebSocketCommands.ARCHIVED:
          _roomArchived();
          break;
        case _WebSocketCommands.ROOM:
          _roomData(commandData);
          break;
        case _WebSocketCommands.CURRENTLY_SPEAKING:
          _currentlySpeaking(commandData);
          break;
        case _WebSocketCommands.SPEECH_STATISTICS:
          _speechStatistics(commandData);
          break;
        case _WebSocketCommands.WANT_TO_SPEAK_ADDED:
          _wantToSpeakAdded();
          break;
        case _WebSocketCommands.WANT_TO_SPEAK_REMOVED:
          _wantToSpeakRemoved();
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

  _speakingList(List<dynamic> entries) {
    List<SpeakingListEntry> ids =
        entries.map((entry) => SpeakingListEntry.fromJson(entry)).toList();
    _streamSpeakers.add(ids);
  }

  _usersSorted(List<dynamic> ids) =>
      _streamSortedUsers.add(ids.map((value) => value.toString()).toList());
  _usersWantToSpeak(List<dynamic> ids) {
    ids = ids.map((value) => SpeakingListEntry.fromJson(value)).toList();
    _streamWantToSpeak.add(ids);
  }

  _roomStarted() => _streamRoomState.add(RoomState.STARTED);
  _roomArchived() => _streamRoomState.add(RoomState.ARCHIVED);
  _roomData(Map<String, dynamic> roomData) =>
      _streamRoomData.add(Room.fromJson(roomData));

  _currentlySpeaking(Map<String, dynamic> data) =>
      _streamCurrentlySpeaking.add(CurrentlySpeaking.fromJson(data));

  _speechStatistics(commandData) =>
      _streamStatistics.add(SpeechStatistic.listFromJson(commandData));

  _wantToSpeakAdded() => _streamWantToSpeakStatus.add(true);
  _wantToSpeakRemoved() => _streamWantToSpeakStatus.add(false);

  _onClosed() {
    print("Websocket closed");
    if (_streamRoomState.isOpen()) _streamRoomState.add(RoomState.DISCONNECTED);
    close();
  }

  _onError(error) {
    print("Websocket error: " + error.toString());
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
    _streamRoomState.close();
    _streamRoomData.close();
    _streamCurrentlySpeaking.close();
    _streamStatistics.close();
    _streamWantToSpeakStatus.close();

    _closed = true;
  }

  Stream<List<User>> getAllUsers() => _streamAllUsers.getStream();
  Stream<List<SpeakingListEntry>> getSpeakingList() =>
      _streamSpeakers.getStream();
  Stream<List<String>> getAllUsersSorted() => _streamSortedUsers.getStream();
  Stream<List<SpeakingListEntry>> getUsersWantToSpeak() =>
      _streamWantToSpeak.getStream();
  Stream<Room> getRoomData() => _streamRoomData.getStream();
  Stream<RoomState> getRoomState() => _streamRoomState.getStream();
  Stream<CurrentlySpeaking> getCurrentlySpeaking() =>
      _streamCurrentlySpeaking.getStream();
  Stream<List<SpeechStatistic>> getStatistics() =>
      _streamStatistics.getStream();
  Stream<bool> getWantToSpeakStatus() => _streamWantToSpeakStatus.getStream();

  String getErrorMessage() {
    if (_errorMessage == null) return "";
    return _errorMessage;
  }

  _sendCommand(String command) {
    print("websocket send: " + command);
    _webSocket.sink.add(command);
  }

  wantToSpeak(String category) {
    String data = _WebSocketCommands.WANT_TO_SPEAK + ":" + category;
    _sendCommand(data);
  }

  doNotWantToSpeak() {
    String data = _WebSocketCommands.WANT_NOT_TO_SPEAK;
    _sendCommand(data);
  }

  changeOrderOfSpeakingList(String userId, int newPosition) {
    String data = _WebSocketCommands.CHANGE_ORDER_SPEAKING_LIST +
        ":" +
        userId +
        "," +
        newPosition.toString();
    _sendCommand(data);
  }

  addUserToSpeakingList(String userId, {String category = ""}) {
    String data = _WebSocketCommands.ADD_USER_TO_SPEAKING_LIST +
        ":" +
        userId +
        " " +
        category;
    _sendCommand(data);
  }

  removeUserFromSpeakingList(String userId) {
    String data =
        _WebSocketCommands.REMOVE_USER_FROM_SPEAKING_LIST + ":" + userId;
    _sendCommand(data);
  }

  start() => _sendCommand(_WebSocketCommands.START);
  stopRoom() => _sendCommand(_WebSocketCommands.STOP_ROOM);
  updateUserList() => _sendCommand(_WebSocketCommands.UPDATE_USER_LIST);
  startSpeech() => _sendCommand(_WebSocketCommands.START_SPEECH);
  pauseSpeech() => _sendCommand(_WebSocketCommands.PAUSE_SPEECH);
  stopSpeech() => _sendCommand(_WebSocketCommands.STOP_SPEECH);
}

enum RoomState { STARTED, DISCONNECTED, ERROR, ARCHIVED }

class _WebSocketCommands {
  // receive

  // only moderator
  static const USERS_SORTED = "sortedList";
  static const USERS_WANT_TO_SPEAK = "wantToSpeakList";
  static const CURRENTLY_SPEAKING = "currentlySpeaking";
  static const SPEECH_STATISTICS = "speechStatistics";

  static const ROOM = "room";
  static const SPEAKING_LIST = "speechList";
  static const STARTED = "started";
  static const ARCHIVED = "archived";
  static const ALL_USERS = "allUsers";
  static const WANT_TO_SPEAK_ADDED = "wts_added";
  static const WANT_TO_SPEAK_REMOVED = "wts_removed";

  // send

  // only moderator
  static const UPDATE_USER_LIST = "updateUserList";
  static const START = "start";
  static const CHANGE_ORDER_SPEAKING_LIST = "changeSortOrder";
  static const ADD_USER_TO_SPEAKING_LIST = "addUserToSpeechList";
  static const REMOVE_USER_FROM_SPEAKING_LIST = "removeUserFromSpeechList";
  static const START_SPEECH = "startSpeech";
  static const PAUSE_SPEECH = "pauseSpeech";
  static const STOP_SPEECH = "stopSpeech";
  static const STOP_ROOM = "archieve";

  static const REGISTER = "register";
  static const WANT_TO_SPEAK = "wantToSpeak";
  static const WANT_NOT_TO_SPEAK = "wantNotToSpeak";
}
