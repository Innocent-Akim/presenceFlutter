import 'package:shared_preferences/shared_preferences.dart';

class Mypreferences {
  static Mypreferences _mypreferences;
  String _stringToken = "asxzfjdksxceexdxcesde";

  static Mypreferences mypreferences() {
    if (_mypreferences == null) {
      _mypreferences = Mypreferences();
    }
    return _mypreferences;
  }

  Future<bool> setToken(String _key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_key, _stringToken);
  }

  Future<bool> getToken(String _key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(preferences.getString(_key));
    if (preferences.getString(_key) != null) {
      return true;
    }
    return false;
  }
}
