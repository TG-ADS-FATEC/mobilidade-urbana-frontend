import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/network/dio_client.dart';
import 'package:mobilidade_urbana_app/features/favorites/data/models/trip_favorite_model.dart';

abstract class TripFavoriteRemoteDatasource {
  Future<List<TripFavoriteModel>> getTrips();
  Future<TripFavoriteModel> addTrip(Map<String, dynamic> data);
  Future<TripFavoriteModel> updateTrip(String id, Map<String, dynamic> data);
  Future<void> deleteTrip(String id);
}

class TripFavoriteRemoteDatasourceImpl implements TripFavoriteRemoteDatasource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<TripFavoriteModel>> getTrips() async {
    final response = await _dio.get('/profiles/favorites/trips');
    return (response.data as List)
        .map((json) => TripFavoriteModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TripFavoriteModel> addTrip(Map<String, dynamic> data) async {
    final response = await _dio.post('/profiles/favorites/trips', data: data);
    return TripFavoriteModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TripFavoriteModel> updateTrip(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('/profiles/favorites/trips/$id', data: data);
    return TripFavoriteModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteTrip(String id) async {
    await _dio.delete('/profiles/favorites/trips/$id');
  }
}
