import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/network/dio_client.dart';
import 'package:mobilidade_urbana_app/features/favorites/data/models/favorite_model.dart';
import 'package:mobilidade_urbana_app/features/profile/data/models/profile_model.dart';

abstract class FavoriteRemoteDatasource {
  Future<FavoriteModel> addFavorite(Map<String, dynamic> data);
  Future<List<FavoriteModel>> getFavorites();
  Future<void> deleteFavorite(String favoriteId);
  Future<FavoriteModel> updateFavorite(String favoriteId, Map<String, dynamic> data);
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDatasource {
  final Dio _dio = DioClient.instance;

  @override
  Future<FavoriteModel> addFavorite(Map<String, dynamic> data) async {
    final response = await _dio.post('/profiles/favorites', data: data);
    return FavoriteModel.fromJson(response.data);
  }

  @override
  Future<List<FavoriteModel>> getFavorites() async {
    final response = await _dio.get('/profiles/favorites');
    return (response.data as List).map((json) => FavoriteModel.fromJson(json)).toList();
  }

  @override
  Future<void> deleteFavorite(String favoriteId) async {
    await _dio.delete('/profiles/favorites/$favoriteId');
  }

  @override
  Future<FavoriteModel> updateFavorite(String favoriteId, Map<String, dynamic> data) async {
    final response = await _dio.put('profiles/favorites/$favoriteId', data: data);
    return FavoriteModel.fromJson(response.data);
  }
}