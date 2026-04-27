import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/network/dio_client.dart';
import 'package:mobilidade_urbana_app/features/profile/data/models/preferences_model.dart';

abstract class OnboardingRemoteDatasource {
  Future<PreferencesModel> savePreferences(Map<String, dynamic> data);
}

class OnboardingRemoteDatasourceImpl implements OnboardingRemoteDatasource {
  final Dio _dio = DioClient.instance;

  @override
  Future<PreferencesModel> savePreferences(Map<String, dynamic> data) async {
    final response = await _dio.post('/preferences', data: data);
    return PreferencesModel.fromJson(response.data);


  }
}