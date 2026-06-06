import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/network/dio_client.dart';
import 'package:mobilidade_urbana_app/features/lines/data/models/line_model.dart';

abstract class LineRemoteDatasource {
  Future<List<LineModel>> getLines();
  Future<List<LineModel>> searchLines(String query);
}

class LineRemoteDataSourceImpl implements LineRemoteDatasource {
  final Dio _dio = DioClient.instance;

  List<dynamic> _extractList(dynamic data, [String key = 'routes']) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final value = data[key] ?? data['data'];
      if (value is List) return value;
    }
    throw FormatException('Unexpected response format: $data');
  }

  @override
  Future<List<LineModel>> getLines() async {
    final response = await _dio.get('/routes');
    return _extractList(response.data)
        .map((json) => LineModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<LineModel>> searchLines(String query) async {
    final response = await _dio.get(
      '/routes/search',
      queryParameters: {'query': query},
    );
    return _extractList(response.data)
        .map((json) => LineModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
