import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/Room.dart';

class RoomApi{

  static const BASE_URL = "http://192.168.178.20:3000";

  Client client = Client();

  Future<Room> createRoom(Room room) async {
    final response = await client.post(BASE_URL + "/room/create", body: json.encode(room.toMap()), headers: getHeaders());

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

  Map getHeaders(){
    var map = new Map<String, String>();
    //TODO
    map["guest_uuid"] = "3kjl3j-343kl34-434";
    map["Content-Type"] = "application/json";

    return map;
  }

}