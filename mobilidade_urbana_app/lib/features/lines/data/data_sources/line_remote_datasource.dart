import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobilidade_urbana_app/core/network/dio_client.dart';
import 'package:mobilidade_urbana_app/features/lines/data/models/line_model.dart';

abstract class LineRemoteDatasource {
  Future<({List<LineModel> items, bool hasNext})> getLines({int page = 0, int size = 20});
  Future<List<LineModel>> searchLines(String query);
}

class LineRemoteDataSourceImpl implements LineRemoteDatasource {
  final Dio _dio = DioClient.instance;

  List<dynamic> _extractList(dynamic data, [String key = 'items']) {
    debugPrint('[_extractList] data runtimeType: ${data.runtimeType}');
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      debugPrint('[_extractList] keys: ${data.keys.toList()}');
      final value = data[key] ?? data['routes'] ?? data['data'];
      debugPrint('[_extractList] value for key "$key": ${value?.runtimeType} | is List: ${value is List}');
      if (value is List) return value;
    }
    throw FormatException('Unexpected response format: $data');
  }

  @override
  Future<({List<LineModel> items, bool hasNext})> getLines({int page = 0, int size = 20}) async {
    final response = await _dio.get('/routes', queryParameters: {'page': page, 'size': size});
    final data = response.data as Map<String, dynamic>;
    final items = _extractList(data)
        .map((json) => LineModel.fromJson(json as Map<String, dynamic>))
        .toList();
    final hasNext = data['hasNext'] as bool? ?? false;
    return (items: items, hasNext: hasNext);
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
