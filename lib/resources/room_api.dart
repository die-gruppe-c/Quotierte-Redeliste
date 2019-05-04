import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:quotierte_redeliste/resources/repository.dart';
import 'package:quotierte_redeliste/models/profile.dart';

import '../models/room.dart';

class RoomApi {
  static const BASE_URL = "http://" + Repository.BASE_URL;

  Client client = Client();

  Future<Room> createRoom(Room room) async {
    final headers = await getHeaders();
    final response = await client.post(BASE_URL + "/room/create",
        body: json.encode(room.toMap()), headers: headers);

    if (response.statusCode == 201) {
      return Room.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create room');
    }
  }

  Future<Room> getRoom(int id) async {
    final response = await client.get(BASE_URL + "/room?id=$id");

    if (response.statusCode == 200) {
      return Room.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load room');
    }
  }

  Future<List<Room>> getAllRooms() async {
    final headers = await getHeaders();
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

  Future<Map> getHeaders() async {
    var map = new Map<String, String>();
    map["guest_uuid"] = await Profile().getToken();
    map["Content-Type"] = "application/json";

    return map;
  }
}
