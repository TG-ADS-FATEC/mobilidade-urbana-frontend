import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/trip_favorite_entity.dart';

abstract class TripFavoriteRepository {
  Future<DataState<List<TripFavoriteEntity>>> getTrips();
  Future<DataState<TripFavoriteEntity>> addTrip(TripFavoriteEntity trip);
  Future<DataState<TripFavoriteEntity>> updateTrip(TripFavoriteEntity trip);
  Future<DataState<void>> deleteTrip(String id);
}
