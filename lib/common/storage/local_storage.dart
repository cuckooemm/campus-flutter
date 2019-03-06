import 'package:shared_preferences/shared_preferences.dart';
///SharedPreferences 本地存储
///
class LocalStorage {
  static saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
  static saveInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }
  static saveBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }
  static getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }
  static getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
  static remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
  static clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}