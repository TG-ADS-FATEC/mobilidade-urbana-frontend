import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/error/failures.dart';
import 'package:mobilidade_urbana_app/core/network/dio_client.dart';
import 'package:mobilidade_urbana_app/core/services/device_token_service.dart';

class AuthService {

  static Future<DataState<List<String>>> authenticate() async {
    final dio = DioClient.instance;
    try {
      final deviceToken = await DeviceTokenService.get();

      final response = await dio.post(
        '/authentication/devices',
        data: {
          'deviceToken': deviceToken,
          'appVersion': '1.0.0',
          'platform': defaultTargetPlatform == TargetPlatform.android
              ? 'ANDROID'
              : 'IOS',
        },
      );

      final jwt = response.data['token'] as String;
      await DeviceTokenService.saveJwt(jwt);
      return DataSuccess([jwt, deviceToken]);

    } on DioException catch (e) {
      debugPrint('[AuthService] Falha: ${e.message}');
      return DataFailed(
        e.type == DioExceptionType.connectionError
            ? NetworkFailure()
            : ServerFailure(e.message ?? 'Falha na autenticação'),
      );
    }
  }
}