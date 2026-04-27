import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/error/failures.dart';
import 'package:mobilidade_urbana_app/core/services/device_token_service.dart';
import 'package:mobilidade_urbana_app/core/services/onboarding_service.dart';
import 'package:mobilidade_urbana_app/features/onboarding/data/data_sources/onboarding_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/profile/data/models/preferences_model.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences.entity.dart';

class OnboardingRepositoryImpl  {
  final OnboardingRemoteDatasource _remoteDataSource;

  OnboardingRepositoryImpl(this._remoteDataSource);

  Future<DataState<PreferencesEntity>> savePreferences({
    required PreferencesEntity preferences,
  }) async {
    try {
      final deviceToken = await DeviceTokenService.get();

      final json = PreferencesModel.fromEntity(preferences).toJson()
        ..['deviceToken'] = deviceToken;

      final model = await _remoteDataSource.savePreferences(json);

      await OnboardingService.setComplete();

      return DataSuccess(model);
    } on DioException catch (e) {
      return DataFailed(
        e.type == DioExceptionType.connectionError
            ? NetworkFailure()
            : ServerFailure(e.message ?? 'Erro no servidor'),
        message: e.message,
      );
    } catch (e) {
      return DataFailed(
        UnknownFailure(e.toString()),
        message: 'Erro inesperado',
      );
    }
  }
}