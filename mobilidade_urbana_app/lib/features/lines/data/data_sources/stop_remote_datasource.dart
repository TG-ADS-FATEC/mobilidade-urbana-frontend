import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/network/dio_client.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/stop_entity.dart';

abstract class StopRemoteDatasource {
  /// Retorna os trips do itinerário, cada um com suas paradas
  /// ordenadas por [stopSequence] e sem duplicatas de stopId.
  Future<List<List<StopEntity>>> getItinerary(String routeId);
}

class StopRemoteDatasourceImpl implements StopRemoteDatasource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<List<StopEntity>>> getItinerary(String routeId) async {
    final response = await _dio.get('/routes/$routeId/itinerary');
    final data = response.data as Map<String, dynamic>;

    final trips = data['trips'] as List? ?? [];

    return trips.map((trip) {
      final rawStops = (trip as Map<String, dynamic>)['stops'] as List? ?? [];

      final stops = rawStops.map((json) {
        final j = json as Map<String, dynamic>;
        return StopEntity(
          id: j['stopId'] as String,
          name: j['stopName'] as String,
          sequence: j['stopSequence'] as int?,
          arrivalTime: j['arrivalTime'] as String?,
        );
      }).toList();

      stops.sort((a, b) => (a.sequence ?? 0).compareTo(b.sequence ?? 0));

      // Remove duplicatas de stopId mantendo a primeira ocorrência.
      final seen = <String>{};
      return stops.where((s) => seen.add(s.id)).toList();
    }).toList();
  }
}
