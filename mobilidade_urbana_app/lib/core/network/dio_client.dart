import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/services/auth_service.dart';
import 'package:mobilidade_urbana_app/core/services/device_token_service.dart';

class DioClient {
  static const _publicRoutes = ['/authentication/devices'];

  static final Dio instance = _build();

  static Dio _build() {
    final dio = Dio(BaseOptions(
      baseUrl: 'http://10.0.2.2:8080',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final isPublic = _publicRoutes.contains(options.path);

        if (!isPublic) {
          final jwt = await DeviceTokenService.getJwt();
          if (jwt != null) {
            options.headers['Authorization'] = 'Bearer $jwt';
          }
        }
        handler.next(options);
      },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final result = await AuthService.authenticate();

            if (result is DataSuccess<String>) {
              final jwt = await DeviceTokenService.getJwt();
              e.requestOptions.headers['Authorization'] = 'Bearer $jwt';
              final retryResponse = await instance.fetch(e.requestOptions);
              handler.resolve(retryResponse);
            } else {
              if (kDebugMode) {
                debugPrint('[DioClient] Falha ao renovar token');
              }
              handler.next(e);
            }
          } else {
            if (kDebugMode) {
              debugPrint(
                '[DioClient] ${e.requestOptions.method} '
                    '${e.requestOptions.path} → ${e.message}',
              );
            }
            handler.next(e);
          }
        },
    ));

    return dio;
  }
}