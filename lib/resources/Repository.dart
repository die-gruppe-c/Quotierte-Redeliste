
import 'package:quotierte_redeliste/models/Room.dart';
import 'package:quotierte_redeliste/resources/RoomApi.dart';

class Repository{

  final roomApi = RoomApi();

  Future<Room> getRoom(int id) => roomApi.getRoom(id);

  Future<Room> createRoom(Room room) => roomApi.createRoom(room);

}