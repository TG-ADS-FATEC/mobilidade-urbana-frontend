
import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/error/failures.dart';
import 'package:mobilidade_urbana_app/core/services/device_token_service.dart';
import 'package:mobilidade_urbana_app/features/profile/data/data_sources/profile_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/profile/data/models/profile_model.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/profile.entity.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/repository/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<DataState<ProfileEntity>> getProfile() async {
    try {
      final model = await _remoteDataSource.getProfile();
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
  Future<DataState<ProfileEntity>> updateProfile({
    required ProfileEntity profile,
  }) async {
    try {
      final model = await _remoteDataSource.updateProfile(
          ProfileModel.fromEntity(profile).toJson(),
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
  Future<DataState<ProfileEntity>> saveProfile({
    required ProfileEntity profile,
  }) async {
    try {
      final model = await _remoteDataSource.updateProfile(
        ProfileModel.fromEntity(profile).toJson(),
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
  Future<DataState<void>> deleteProfile() async {
    try {
      await _remoteDataSource.deleteProfile();

      await DeviceTokenService.deleteJwt();
      await DeviceTokenService.delete();

      return const DataSuccess(null);
    } on DioException catch (e) {
      return DataFailed(
        e.type == DioExceptionType.connectionError
            ? NetworkFailure()
            : ServerFailure(e.message ?? 'Erro ao deletar conta'),
      );
    }
  }
}

