

import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/error/failures.dart';
import 'package:mobilidade_urbana_app/features/favorites/data/data_sources/favorite_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/favorites/data/models/favorite_model.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/repository/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository{
  final FavoriteRemoteDatasource _remoteDataSource;
  
  FavoriteRepositoryImpl(this._remoteDataSource);

  @override
  Future<DataState<List<FavoriteEntity>>> getFavorites() async {
    try {
      final model = await _remoteDataSource.getFavorites();
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
  Future<DataState<FavoriteEntity>> addFavorite(FavoriteEntity favorite) async {
    try {
      final model = await _remoteDataSource.addFavorite(
        FavoriteModel.fromEntity(favorite).toJson(),
      );
      return DataSuccess(model);
    } on DioException catch (e) {
      return DataFailed(
        e.type == DioExceptionType.connectionError
            ? NetworkFailure()
            : ServerFailure(e.message ?? 'Erro no servidor'),
      );
    }
  }

  @override
  Future<DataState<void>> deleteFavorite(String id) async {
    try {
      await _remoteDataSource.deleteFavorite(id);
      return const DataSuccess(null);
    } on DioException catch (e) {
      return DataFailed(
        e.type == DioExceptionType.connectionError
            ? NetworkFailure()
            : ServerFailure(e.message ?? 'Erro no servidor'),
      );
    }
  }

  @override
  Future<DataState<FavoriteEntity>> updateFavorite(FavoriteEntity favorite) async {
    try {

      final model = await _remoteDataSource.updateFavorite(
        favorite.favoriteId.toString(),
        FavoriteModel.fromEntity(favorite).toJson(),
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
}
