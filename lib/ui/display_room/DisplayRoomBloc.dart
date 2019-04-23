

import 'package:quotierte_redeliste/models/Attribute.dart';
import 'package:quotierte_redeliste/models/Room.dart';
import 'package:quotierte_redeliste/resources/Repository.dart';

class DisplayRoomBloc{

  final _repository = Repository();

  Room _room;

  getName() => _room.name;

  loadRoom(int id, callback({String error})) async{
    _repository.getRoom(id).then((room) {
      _room = room;
      callback();
    }).catchError((e) => callback(error: e.toString()));
  }
  
}

final displayRoomBloc = DisplayRoomBloc();