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
          if (kDebugMode) debugPrint('[DioClient] JWT: $jwt');
          if (jwt != null) {
            options.headers['Authorization'] = 'Bearer $jwt';
          }
        }

        if (kDebugMode) {
          debugPrint('[DioClient] ${options.method} ${options.path}');
        }

        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          debugPrint(
            '[DioClient] ${response.requestOptions.method} '
                '${response.requestOptions.path} → ${response.statusCode}',
          );
        }
        handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (kDebugMode) {
          debugPrint(
            '[DioClient] ${e.requestOptions.method} '
                '${e.requestOptions.path} → ${e.response?.statusCode ?? e.message}',
          );
        }

        final isRetry = e.requestOptions.extra['retried'] == true;

        if (e.response?.statusCode == 401 && !isRetry) {
          final result = await AuthService.authenticate();

          if (result is DataSuccess) {
            final jwt = await DeviceTokenService.getJwt();
            e.requestOptions.headers['Authorization'] = 'Bearer $jwt';
            e.requestOptions.extra['retried'] = true;
            final retryResponse = await instance.fetch(e.requestOptions);
            handler.resolve(retryResponse);
          } else {
            if (kDebugMode) debugPrint('[DioClient] Falha ao renovar token');
            handler.next(e);
          }
        } else {
          handler.next(e);
        }
      },
    ));

    return dio;
  }
}
