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
  static const TAG_DARK_MODE = 'darkMode';

  String _username;
  String _token;
  bool _darkMode;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> getUsername() async {
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

  Future<bool> darkModeEnabled() async {
    if (_darkMode == null) {
      final SharedPreferences prefs = await _prefs;
      _darkMode = prefs.getBool(TAG_DARK_MODE);
    }

    if (_darkMode == null) _darkMode = false;

    return _darkMode;
  }

  setDarkMode(bool enabled) async {
    _darkMode = enabled;

    final SharedPreferences prefs = await _prefs;
    prefs.setBool(TAG_DARK_MODE, enabled);
  }

  setToken(String token) async {
    _token = token;

    final SharedPreferences prefs = await _prefs;
    prefs.setString(TAG_TOKEN, token);
  }

  Future<String> getToken() async {
    if (_token == null) {
      final SharedPreferences prefs = await _prefs;

      if (!prefs.containsKey(TAG_TOKEN)) {
        _token = generateToken();
        prefs.setString(TAG_TOKEN, _token);
      } else {
        _token = prefs.getString(TAG_TOKEN);
      }
    }

    return _token;
  }

  static String generateToken() {
    var uuid = new Uuid();
    return uuid.v4();
  }

  static bool isInDebugMode() {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}
