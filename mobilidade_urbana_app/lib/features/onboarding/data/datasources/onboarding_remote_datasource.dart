
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:mobilidade_urbana_app/core/network/dio_client.dart';
import 'package:mobilidade_urbana_app/features/onboarding/data/models/onboarding_model.dart';
import 'package:mobilidade_urbana_app/features/onboarding/data/models/syng_result_model.dart';


class OnboardingRemoteDatasource {
  final _dio = DioClient.instance;

  Future<SyncResult> send(OnboardingModel data) async {
    try {
      final response = await _dio.post('/devices', data: data.toJson());

      switch (response.statusCode) {
        case 201:
          return SyncResult.created;      // ← só retorna, sem tocar no Hive

        case 409:
          final existing = await _dio.get('/devices/${data.deviceToken}');
          final isSameDevice = existing.data['device_token'] == data.deviceToken;
          return isSameDevice ? SyncResult.alreadyExists : SyncResult.collision;

        default:
          return SyncResult.failed;
      }
    } on DioException catch (e) {
      debugPrint('[OnboardingRemoteDatasource] Falha: ${e.message}');
      return SyncResult.failed;
    }
  }
}