import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilidade_urbana_app/utils/http/dio_client.dart';
import 'package:mobilidade_urbana_app/utils/device/device_token_service.dart';

class DeviceRegisterService {
  static final _dio = DioClient.instance;
  static const _deviceIdKey = 'device_id';

  static Future<bool> register() async {
    try {
      final token = await DeviceTokenService.get();

      final response = await _dio.post(
        '/devices',
        data: {
          'deviceToken': token,
          'platform': defaultTargetPlatform == TargetPlatform.android
              ? 'ANDROID'
              : 'IOS',
          'appVersion': '1.0.0',
        },
      );

      if (response.statusCode == 201 || response.statusCode == 409) {
        if (response.statusCode == 201) {
          final deviceId = response.data['deviceId'] as int;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt(_deviceIdKey, deviceId);
        }
        return true;
      }
      return false;
    } on DioException catch (e) {
      debugPrint('[DeviceRegisterService] Falha: ${e.message}');
      return false;
    }
  }

  static Future<int?> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_deviceIdKey);
  }
}