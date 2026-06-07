import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/network/dio_client.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/stop_entity.dart';

abstract class StopRemoteDatasource {
  Future<List<StopEntity>> getStopsByRoute(String routeId);
}

class StopRemoteDatasourceImpl implements StopRemoteDatasource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<StopEntity>> getStopsByRoute(String routeId) async {
    final response = await _dio.get('/stops/$routeId/stops', queryParameters: {'size': 9999});
    final data = response.data as Map<String, dynamic>;
    final items = data['items'] as List? ?? [];
    return items.map((json) => StopEntity(
      id: json['stopId'] as String,
      name: json['stopName'] as String,
      description: json['stopDescription'] as String?,
      latitude: (json['stopLatitude'] as num?)?.toDouble(),
      longitude: (json['stopLongitude'] as num?)?.toDouble(),
    )).toList();
  }
}
