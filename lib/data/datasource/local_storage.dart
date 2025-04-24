import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences _prefs;
  
  LocalStorage._({required SharedPreferences prefs}) : _prefs = prefs;
  
  static Future<LocalStorage> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorage._(prefs: prefs);
  }
  
  // Save data
  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }
  
  Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }
  
  Future<bool> saveDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }
  
  Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }
  
  Future<bool> saveJson(String key, Map<String, dynamic> value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }
  
  Future<bool> saveJsonList(String key, List<Map<String, dynamic>> value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }
  
  // Retrieve data
  String? getString(String key) {
    return _prefs.getString(key);
  }
  
  int? getInt(String key) {
    return _prefs.getInt(key);
  }
  
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }
  
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }
  
  Map<String, dynamic>? getJson(String key) {
    final String? jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Error parsing JSON: $e');
      return null;
    }
  }
  
  List<Map<String, dynamic>>? getJsonList(String key) {
    final String? jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error parsing JSON list: $e');
      return null;
    }
  }
  
  // Remove data
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }
  
  // Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
  
  // Clear all data
  Future<bool> clear() async {
    return await _prefs.clear();
  }
}