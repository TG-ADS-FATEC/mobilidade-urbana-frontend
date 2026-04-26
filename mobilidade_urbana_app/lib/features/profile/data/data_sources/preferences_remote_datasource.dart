

import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/network/dio_client.dart';
import 'package:mobilidade_urbana_app/features/profile/data/models/preferences_model.dart';

abstract class PreferencesRemoteDatasource {
  Future<PreferencesModel> getPreferences();
  Future<PreferencesModel> savePreferences(Map<String, dynamic> data);
  Future<PreferencesModel> updatePreferences(Map<String, dynamic> data);
  Future<void> deletePreferences();
}


class PreferencesRemoteDatasourceImpl implements PreferencesRemoteDatasource {
  final Dio _dio = DioClient.instance;

  @override
  Future<PreferencesModel> getPreferences() async {
    final response = await _dio.get('/preferences');
    return PreferencesModel.fromJson(response.data);
  }

  @override
  Future<PreferencesModel> updatePreferences(Map<String, dynamic> data) async {
    final response = await _dio.put('/preferences', data: data);
    return PreferencesModel.fromJson(response.data);

  }

  @override
  Future<PreferencesModel> savePreferences(Map<String, dynamic> data) async {
    final response = await _dio.post('/preferences', data: data);
    return PreferencesModel.fromJson(response.data);
  }

  @override
  Future<void> deletePreferences() async {
    await _dio.delete('/preferences');
  }


}