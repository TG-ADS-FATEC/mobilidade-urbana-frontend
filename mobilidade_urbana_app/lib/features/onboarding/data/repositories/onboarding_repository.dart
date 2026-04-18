
import 'package:flutter/foundation.dart';
import 'package:mobilidade_urbana_app/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:mobilidade_urbana_app/features/onboarding/data/datasources/onboarding_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/onboarding/data/models/onboarding_model.dart';
import 'package:mobilidade_urbana_app/utils/device/device_token_service.dart';
import 'package:mobilidade_urbana_app/features/onboarding/data/models/syng_result_model.dart';


class OnboardingRepository {
  final OnboardingLocalDatasource _local;
  final OnboardingRemoteDatasource _remote;

  OnboardingRepository(this._local, this._remote);

  Future<void> savePreferences({
    required List<String> transports,
    required String routePreference,
    required bool slowWalking,
    required double walkingDuration,
  }) async {
    // 1. Busca o token do dispositivo
    final deviceToken = await DeviceTokenService.get();

    // 2. Monta o model
    final model = OnboardingModel(
      deviceToken: deviceToken,
      transportPreferences: transports,
      selectedRoutePreference: routePreference,
      slowWalkingPace: slowWalking,
      walkingDuration: walkingDuration,
      isCompleted: true,
    );

    // 3. Salva localmente primeiro
    await _local.save(model);

    // 4. Tenta sincronizar com o Spring
    final result = await _remote.send(model);

    // 5. Atualiza status de sync conforme resultado
    switch (result) {
      case SyncResult.created:
      case SyncResult.alreadyExists:
        await _local.markAsSynced();
        break;

      case SyncResult.collision:
        debugPrint('[OnboardingRepository] Colisão de token detectada');
        break;

      case SyncResult.failed:
        debugPrint('[OnboardingRepository] Falha ao sincronizar — salvo localmente');
        break;
    }
  }

  bool get isCompleted => _local.isCompleted;
  bool get isSynced => _local.isSynced;

  OnboardingModel? load() => _local.load();
}