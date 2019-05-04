import 'package:quotierte_redeliste/models/room.dart';
import 'package:quotierte_redeliste/resources/room_api.dart';

class Repository {
  final roomApi = RoomApi();

  Future<Room> getRoom(int id) => roomApi.getRoom(id);

  Future<Room> createRoom(Room room) => roomApi.createRoom(room);

  Future<List<Room>> getAllRooms() => roomApi.getAllRooms();
}
