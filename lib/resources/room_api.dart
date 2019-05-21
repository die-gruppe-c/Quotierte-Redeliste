import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:quotierte_redeliste/models/profile.dart';
import 'package:quotierte_redeliste/resources/repository.dart';

import '../models/room.dart';

class RoomApi {
  static const BASE_URL = "https://" + Repository.BASE_URL;

  Client client = Client();

  Future<Room> createRoom(Room room) async {
    final headers = await _getHeaders();
    final response = await client.post(BASE_URL + "/room/create",
        body: json.encode(room.toMap()), headers: headers);

    if (response.statusCode == 201) {
      return Room.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create room: \n' + response.body);
    }
  }

  Future<Room> getRoom(int id) async {
    final response = await client.get(BASE_URL + "/room?id=$id");

    if (response.statusCode == 200) {
      return Room.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to load room: ' + response.body != null ? response.body : "");
    }
  }

  Future<List<Room>> getAllRooms() async {
    final headers = await _getHeaders();
    final response = await client.get(BASE_URL + "/room", headers: headers);

    if (response.statusCode == 200) {
      List<Room> rooms = List<Room>();

      List decodedJson = json.decode(response.body);
      decodedJson.forEach((roomJson) {
        rooms.add(Room.fromJson(roomJson));
      });
      return rooms;
    } else {
      throw Exception("Failed to load rooms, status: " +
          response.statusCode.toString() +
          ", body: " +
          response.body);
    }
  }

  Future<Room> getRoomToJoin() async {
    final headers = await _getHeaders();
    final response =
        await client.get(BASE_URL + "/room/rejoin", headers: headers);

    if (response.statusCode == 200) {
      if (response.body.length > 1) {
        Map decodedJson = json.decode(response.body);
        return Room.fromJson(decodedJson);
      } else {
        return null;
      }
    } else {
      throw Exception("Failed to load rejoin, status: " +
          response.statusCode.toString() +
          ", body: " +
          response.body);
    }
  }

  /// attributes: key is the name of the attribute,
  ///             value is the selected value for the attribute
  /// name: username
  /// uuid: only when the moderator adds a user
  Future<void> joinRoom(
      String roomId, String name, Map<String, String> attributes,
      {String uuid}) async {
    final headers = await _getHeaders();
    final body = Map<String, dynamic>();

    body["roomId"] = roomId;
    body["name"] = name;
    if (uuid != null) body["uuid"] = uuid;

    // Attributes
    body["attributes"] = _getAttributesJsonFromMap(attributes);

    final response = await client.post(BASE_URL + "/room/join",
        body: json.encode(body), headers: headers);

    if (response.statusCode == 201) {
      print("Room created: " + response.body);
      return;
    } else {
      throw Exception('Fehler beim beitreten: \n' + response.body);
    }
  }

  List<Map<String, dynamic>> _getAttributesJsonFromMap(
      Map<String, String> attributes) {
    List<Map<String, dynamic>> attributesList = List();

    attributes.forEach((key, value) {
      Map<String, dynamic> oneAttributeMap = Map();
      oneAttributeMap["name"] = key;

      List<Map<String, String>> valueList = List();
      Map<String, String> valueMap = Map();
      valueMap["name"] = value;
      valueList.add(valueMap);

      oneAttributeMap["values"] = valueList;
      attributesList.add(oneAttributeMap);
    });

    return attributesList;
  }

  Future<Map> _getHeaders() async {
    var map = new Map<String, String>();
    map["guest_uuid"] = await Profile().getToken();
    map["Content-Type"] = "application/json";

    return map;
  }
}
