import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/error/failures.dart';
import 'package:mobilidade_urbana_app/features/favorites/data/data_sources/trip_favorite_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/favorites/data/models/trip_favorite_model.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/trip_favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/repository/trip_favorite_repository.dart';

class TripFavoriteRepositoryImpl implements TripFavoriteRepository {
  final TripFavoriteRemoteDatasource _remote;

  TripFavoriteRepositoryImpl(this._remote);

  AppFailure _handle(DioException e) =>
      e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout
          ? NetworkFailure()
          : ServerFailure(e.message ?? 'Erro no servidor');

  @override
  Future<DataState<List<TripFavoriteEntity>>> getTrips() async {
    try {
      return DataSuccess(await _remote.getTrips());
    } on DioException catch (e) {
      return DataFailed(_handle(e));
    }
  }

  @override
  Future<DataState<TripFavoriteEntity>> addTrip(TripFavoriteEntity trip) async {
    try {
      return DataSuccess(await _remote.addTrip(TripFavoriteModel.fromEntity(trip).toJson()));
    } on DioException catch (e) {
      return DataFailed(_handle(e));
    }
  }

  @override
  Future<DataState<TripFavoriteEntity>> updateTrip(TripFavoriteEntity trip) async {
    try {
      return DataSuccess(await _remote.updateTrip(
        trip.id!,
        TripFavoriteModel.fromEntity(trip).toJson(),
      ));
    } on DioException catch (e) {
      return DataFailed(_handle(e));
    }
  }

  @override
  Future<DataState<void>> deleteTrip(String id) async {
    try {
      await _remote.deleteTrip(id);
      return const DataSuccess(null);
    } on DioException catch (e) {
      return DataFailed(_handle(e));
    }
  }
}
