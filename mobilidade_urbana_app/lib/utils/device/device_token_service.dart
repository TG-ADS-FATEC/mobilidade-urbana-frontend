import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceTokenService {
  static const _key = 'device_token';
  static const _uuid = Uuid(); //

  static Future<String> get() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_key);
    if (existing != null) return existing;
    return _create(prefs);
  }

  static Future<String> regenerate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    return _create(prefs);
  }

  static Future<String> _create(SharedPreferences prefs) async {
    final token = _uuid.v4();
    await prefs.setString(_key, token);
    return token;
  }
}