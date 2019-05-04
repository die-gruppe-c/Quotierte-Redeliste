import 'package:quotierte_redeliste/models/room.dart';
import 'package:quotierte_redeliste/resources/room_api.dart';
import 'package:quotierte_redeliste/resources/room_websocket.dart';

class Repository {
  static const BASE_URL = "192.168.178.20:3000";

  final roomApi = RoomApi();
  final roomWebSocket = RoomWebSocket();

  Future<Room> getRoom(int id) => roomApi.getRoom(id);

  Future<Room> createRoom(Room room) => roomApi.createRoom(room);

  RoomWebSocket webSocket() => roomWebSocket;

  Future<List<Room>> getAllRooms() => roomApi.getAllRooms();
}
