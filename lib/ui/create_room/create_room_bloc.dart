import 'package:quotierte_redeliste/models/attribute.dart';
import 'package:quotierte_redeliste/models/attribute_value.dart';
import 'package:quotierte_redeliste/models/room.dart';
import 'package:quotierte_redeliste/resources/repository.dart';

class CreateRoomBloc {
  final _repository = Repository();

  Room _room;

  createNewRoom() {
    _room = Room();
    var attribute = Attribute("");
    attribute.values.add(AttributeValue(""));
    _room.attributes.add(attribute);
  }

  setRoomName(String name) {
    _room.name = name;
  }

  getAttribute(int idx) {
    return _room.attributes[idx];
  }

  getAttributeCount() {
    return _room.attributes.length;
  }

  addAttribute(Attribute attribute) {
    _room.attributes.add(attribute);
  }

  removeAttribute(int idx) {
    _room.attributes.removeAt(idx);
  }

  postNewRoom(callback({Room result, String error})) async {
    var roomToPost = Room.clone(_room);

    _repository
        .createRoom(roomToPost)
        .then((room) => callback(result: room))
        .catchError((e) => callback(error: e.toString()));
  }
}

final createRoomBloc = CreateRoomBloc();
