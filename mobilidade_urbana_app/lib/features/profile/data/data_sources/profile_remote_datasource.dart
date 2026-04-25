import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/network/dio_client.dart';
import 'package:mobilidade_urbana_app/features/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(Map<String, dynamic> data);
  Future<void> deleteProfile();
}


class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio = DioClient.instance;

  @override
  Future<ProfileModel> getProfile() async {
    final response = await _dio.get('/profile');
    return ProfileModel.fromJson(response.data);
  }

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> data) async {
    final response = await _dio.put('/profile', data: data);
    return ProfileModel.fromJson(response.data);

  }

  @override
  Future<void> deleteProfile() async {
    await _dio.delete('/profile');
  }
}