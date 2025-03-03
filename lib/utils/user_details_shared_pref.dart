import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsSharedPref {
  static SharedPreferences? _preferences;

  static const jwtToken = 'access';
  static const userName = 'username';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  return _preferences!;
  }

  static Future setToken(String token) async {
     await _preferences!.setString(jwtToken, token);
  }
  static String? getUserToken()  => _preferences!.getString(jwtToken);

  static String? getUserName() => _preferences!.getString(userName);

  static Future setUserName(String username) async {
    await _preferences!.setString(userName, username);
  }



}