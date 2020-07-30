import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static SessionManager _instance;
  static SharedPreferences _sharedPreference;

  static const String USER_ID = "USER_ID";
  static const String USER_ROLE = "USER_ROLE";

  static Future<SessionManager> getInstance() async {
    if (_instance == null) {
      _instance = new SessionManager();
      await _instance._init();
    }
    return _instance;
  }

  Future _init() async {
    _sharedPreference = await SharedPreferences.getInstance();
  }

  setUserId(int userId) async {
    if (_sharedPreference == null) return null;
    return await _sharedPreference.setInt(USER_ID, userId);
  }

  int getUserId() {
    if (_sharedPreference == null) return null;
    return _sharedPreference.getInt(USER_ID) ?? 0;
  }

  setRole(String role) async {
    if (_sharedPreference == null) return null;
    return await _sharedPreference.setString(USER_ROLE, role);
  }

  String getRole() {
    if (_sharedPreference == null) return null;
    return _sharedPreference.getString(USER_ROLE) ?? null;
  }

  clear() async {
    if (_sharedPreference == null) return null;
    return await _sharedPreference.clear();
  }
}
