import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/network/dio_client.dart';
import 'package:mobilidade_urbana_app/features/lines/data/models/line_model.dart';

abstract class LineRemoteDatasource {
  Future<List<LineModel>> getLines();
  Future<List<LineModel>> searchLines(String query);
}

class LineRemoteDataSourceImpl implements LineRemoteDatasource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<LineModel>> getLines() async {
    final response = await _dio.get('/routes');
    return (response.data as List)
        .map((json) => LineModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<LineModel>> searchLines(String query) async {
    final response = await _dio.get(
      '/routes/search',
      queryParameters: {'query': query},
    );
    return (response.data as List)
        .map((json) => LineModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
