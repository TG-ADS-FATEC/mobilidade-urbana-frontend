

import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/error/failures.dart';
import 'package:mobilidade_urbana_app/features/profile/data/data_sources/preferences_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences.entity.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/repository/preferences_repository.dart';
import 'package:mobilidade_urbana_app/features/profile/data/models/preferences_model.dart';

class PreferencesRepositoryImpl implements PreferencesRepository{
  final PreferencesRemoteDatasource _remoteDataSource;

  PreferencesRepositoryImpl(this._remoteDataSource);

  @override
  Future<DataState<PreferencesEntity>> getPreference() async {
    try {
      final model = await _remoteDataSource.getPreferences();
      return DataSuccess(model);
    } on DioException catch (e) {
      return DataFailed(
          e.type == DioExceptionType.connectionError
              ? NetworkFailure()
              : ServerFailure(e.message ?? 'Erro no servidor')
      );
    }
  }

  @override
  Future<DataState<PreferencesEntity>> savePreference({required PreferencesEntity preferences}) async {
    try {
      final model = await _remoteDataSource.savePreferences(
        PreferencesModel.fromEntity(preferences).toJson(),
      );
      return DataSuccess(model);
    } on DioException catch (e) {
      return DataFailed(
          e.type == DioExceptionType.connectionError
              ? NetworkFailure()
              : ServerFailure(e.message ?? 'Erro no servidor')
      );
    }
  }

  @override
  Future<DataState<PreferencesEntity>> updatePreference({required PreferencesEntity preferences}) async {
    try {
      final model = await _remoteDataSource.updatePreferences(
        PreferencesModel.fromEntity(preferences).toJson(),
      );
      return DataSuccess(model);
    } on DioException catch (e) {
      return DataFailed(
          e.type == DioExceptionType.connectionError
              ? NetworkFailure()
              : ServerFailure(e.message ?? 'Erro no servidor')
      );
    }
  }

  @override
  Future<DataState<void>> deletePreference() async {
    try {
      await _remoteDataSource.deletePreferences();
      return const DataSuccess(null);
    } on DioException catch (e) {
      return DataFailed(
        e.type == DioExceptionType.connectionError
            ? NetworkFailure()
            : ServerFailure(e.message ?? 'Erro no servidor'),
      );
    }
  }
}