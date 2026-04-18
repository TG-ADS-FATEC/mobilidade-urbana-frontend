import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobilidade_urbana_app/utils/device/device_token_service.dart';

class DioClient {
  static final Dio instance = _build();

  static Dio _build() {
    final dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.10.100:8080',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final isPublic = options.path == '/devices';

        if (!isPublic) {
          final token = await DeviceTokenService.get();
          options.headers['X-Device-Token'] = token;
        }

        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (DioException e, handler) {
        if (kDebugMode) {
          debugPrint(
            '[DioClient] ${e.requestOptions.method} '
                '${e.requestOptions.path} → ${e.message}',
          );
        }
        handler.next(e);
      },
    ));

    return dio;
  }
}