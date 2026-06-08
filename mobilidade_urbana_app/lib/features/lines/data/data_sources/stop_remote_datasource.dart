import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/network/dio_client.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/stop_entity.dart';

abstract class StopRemoteDatasource {
  Future<List<List<StopEntity>>> getItinerary(String routeId);
}

class StopRemoteDatasourceImpl implements StopRemoteDatasource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<List<StopEntity>>> getItinerary(String routeId) async {
    // Busca itinerário (ordem) e coordenadas em paralelo.
    final results = await Future.wait([
      _dio.get('/routes/$routeId/itinerary'),
      _dio.get('/stops/$routeId/stops', queryParameters: {'size': 9999}),
    ]);

    final itineraryData = results[0].data as Map<String, dynamic>;
    final stopsData = results[1].data as Map<String, dynamic>;

    // Monta mapa stopId → coordenadas.
    final coordMap = <String, ({double lat, double lng})>{};
    final rawCoords = stopsData['items'] as List? ?? [];
    for (final s in rawCoords) {
      final j = s as Map<String, dynamic>;
      final id = j['stopId'] as String?;
      final lat = (j['stopLatitude'] as num?)?.toDouble();
      final lng = (j['stopLongitude'] as num?)?.toDouble();
      if (id != null && lat != null && lng != null) {
        coordMap[id] = (lat: lat, lng: lng);
      }
    }

    final trips = itineraryData['trips'] as List? ?? [];

    return trips.map((trip) {
      final rawStops = (trip as Map<String, dynamic>)['stops'] as List? ?? [];

      final stops = rawStops.map((json) {
        final j = json as Map<String, dynamic>;
        final id = j['stopId'] as String;
        final coords = coordMap[id];
        return StopEntity(
          id: id,
          name: j['stopName'] as String,
          sequence: j['stopSequence'] as int?,
          arrivalTime: j['arrivalTime'] as String?,
          latitude: coords?.lat,
          longitude: coords?.lng,
        );
      }).toList();

      stops.sort((a, b) => (a.sequence ?? 0).compareTo(b.sequence ?? 0));

      final seen = <String>{};
      return stops.where((s) => seen.add(s.id)).toList();
    }).toList();
  }
}
