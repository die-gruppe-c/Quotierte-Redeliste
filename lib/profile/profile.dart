import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Profile {
  // Singleton pattern
  static final Profile _singleton = new Profile._internal();

  factory Profile() {
    return _singleton;
  }

  Profile._internal();
  // End Singleton pattern

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future getUsername() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('username');
  }

  setUsername(String username) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('username', username);
  }

  getToken() async {
    final SharedPreferences prefs = await _prefs;

    if (prefs.containsKey('usertoken')) {
      String uuid = _generateToken();
      prefs.setString('usertoken', uuid);
      return uuid;
    }

    return prefs.getString('usertoken');
  }

  static String _generateToken() {
    var uuid = new Uuid();
    return uuid.v4();
  }
}
