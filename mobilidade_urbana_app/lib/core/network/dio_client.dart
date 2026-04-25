import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobilidade_urbana_app/utils/device/device_token_service.dart';

class DioClient {
  static const _publicRoutes = ['/devices'];

  static final Dio instance = _build();

  static Dio _build() {
    final dio = Dio(BaseOptions(
      // baseUrl: dotenv.env['BASE_URL'] ?? 'http://localhost:8080',
      baseUrl: 'http://localhost:8080',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final isPublic = _publicRoutes.contains(options.path);

        if (!isPublic) {
          final token = await DeviceTokenService.get();
          options.headers['X-Device-Token'] = token;
        }

        handler.next(options);
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