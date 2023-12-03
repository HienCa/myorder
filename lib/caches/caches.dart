import 'package:shared_preferences/shared_preferences.dart';

class MyCacheManager {
  static final MyCacheManager _instance = MyCacheManager._internal();

  factory MyCacheManager() {
    return _instance;
  }

  MyCacheManager._internal();

  Future<void> addToCache(String key, dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data.toString());
  }

  Future<String?> getFromCache(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  //bool
  Future<void> addToCacheBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool?> getFromCacheBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  //DateTime
  Future<void> addToCacheDateTime(String key, DateTime value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String formattedDateTime = value.toIso8601String();
    await prefs.setString(key, formattedDateTime);
  }

  Future<DateTime?> getFromCacheDateTime(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedDateTime = prefs.getString(key);

    if (storedDateTime != null) {
      // If the storedDateTime is not null, parse it back to DateTime
      return DateTime.parse(storedDateTime);
    }

    return null;
  }
  
  //Object
  // Future<void> addToCache(String key, dynamic data) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String jsonString = jsonEncode(data);
  //   await prefs.setString(key, jsonString);
  // }

  // Future<T?> getFromCache<T>(String key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? jsonString = prefs.getString(key);

  //   if (jsonString != null) {
  //     // If the jsonString is not null, decode it and return the object
  //     return jsonDecode(jsonString) as T;
  //   }

  //   return null;
  // }

  Future<bool> isInCache(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
