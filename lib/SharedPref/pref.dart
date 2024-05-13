import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _prefs;

  // Call this method from initState() function of mainApp().
  // Explicitly initialize _prefs and return it.
  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  //sets
  // ignore: type_annotate_public_apis
  static Future<bool> setBool(String key, value) async {
    assert(value != null, 'value passed was null!');
    return _prefs.setBool(key, value);
  }

  static Future<bool> setDouble(String key, double value) async =>
      _prefs.setDouble(key, value);

  static Future<bool> setInt(String key, int value) async =>
      _prefs.setInt(key, value);

  static Future<bool> setString(String key, String value) async =>
      _prefs.setString(key, value);

  static Future<bool> setStringList(String key, List<String> value) async =>
      _prefs.setStringList(key, value);

  static Future setJsonData(String key, Map<String, dynamic> jsonMap) async {
    await _prefs.setString(key, json.encode(jsonMap));
  }

  //gets
  static bool? getBool(String key) => _prefs.getBool(key) ?? false;

  static double? getDouble(String key) => _prefs.getDouble(key);

  static int? getInt(String key) => _prefs.getInt(key);

  static String? getString(String key) => _prefs.getString(key);

  static List<String>? getStringList(String key) => _prefs.getStringList(key);

  static Future<Map<String, dynamic>> readJson(String key) async {
    Map<String, dynamic> map = json.decode(_prefs.getString(key) ?? "");
    return map;
  }

  //deletes..
  static Future<bool> remove(String key) async => _prefs.remove(key);

  static Future<bool> clear() async => _prefs.clear();
  static Future<bool> contains({required String key}) async =>
      _prefs.containsKey(key);
}
