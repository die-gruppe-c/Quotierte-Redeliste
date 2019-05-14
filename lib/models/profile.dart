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
  static const TAG_USERNAME = 'username';
  static const TAG_TOKEN = 'usertoken';

  String _username;
  String _token;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future getUsername() async {
    if (_username == null) {
      final SharedPreferences prefs = await _prefs;
      _username = prefs.getString(TAG_USERNAME);
    }

    return _username;
  }

  setUsername(String username) async {
    _username = username;

    final SharedPreferences prefs = await _prefs;
    prefs.setString(TAG_USERNAME, username);
  }

  // TODO only for test purpose
  setToken(String token) async {
    _token = token;

    final SharedPreferences prefs = await _prefs;
    prefs.setString(TAG_TOKEN, token);
  }

  Future<String> getToken() async {
    if (_token == null) {
      final SharedPreferences prefs = await _prefs;

      if (!prefs.containsKey(TAG_TOKEN)) {
        _token = _generateToken();
        prefs.setString(TAG_TOKEN, _token);
      } else {
        _token = prefs.getString(TAG_TOKEN);
      }
    }

    return _token;
  }

  static String _generateToken() {
    var uuid = new Uuid();
    return uuid.v4();
  }
}
