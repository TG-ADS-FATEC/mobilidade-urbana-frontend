import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/network/dio_client.dart';
import 'package:mobilidade_urbana_app/features/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String deviceToken);
  Future<ProfileModel> updateProfile(String deviceToken, Map<String, dynamic> data);
}


class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio = DioClient.instance;

  @override
  Future<ProfileModel> getProfile(String deviceToken) async {
    final response = await _dio.get('/profile', queryParameters: {'deviceToken': deviceToken});
    return ProfileModel.fromJson(response.data);
  }

  @override
  Future<ProfileModel> updateProfile(String deviceToken, Map<String, dynamic> data) async {
    final response = await _dio.put('/profile', queryParameters: {'deviceToken': deviceToken}, data: data);
    return ProfileModel.fromJson(response.data);

  }

}