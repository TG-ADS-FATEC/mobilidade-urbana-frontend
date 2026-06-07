import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/core/di/service_locator.dart';
import 'package:mobilidade_urbana_app/features/lines/data/data_sources/stop_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/stop_entity.dart';

class LineDetailState {
  final bool isLoading;
  final String? errorMessage;
  final List<StopEntity> stops;

  const LineDetailState({
    this.isLoading = false,
    this.errorMessage,
    this.stops = const [],
  });

  LineDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<StopEntity>? stops,
  }) =>
      LineDetailState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        stops: stops ?? this.stops,
      );
}

class LineDetailNotifier extends FamilyNotifier<LineDetailState, LineEntity> {
  late StopRemoteDatasource _datasource;

  @override
  LineDetailState build(LineEntity line) {
    // Metrô e trem já têm paradas locais — não precisa buscar na API.
    if (line.type != LineType.bus) return const LineDetailState();

    _datasource = sl<StopRemoteDatasource>();
    Future.microtask(_loadStops);
    return const LineDetailState(isLoading: true);
  }

  Future<void> _loadStops() async {
    final routeId = arg.id;
    if (routeId == null) {
      state = state.copyWith(isLoading: false, errorMessage: 'ID da linha não encontrado');
      return;
    }
    try {
      final stops = await _datasource.getStopsByRoute(routeId);
      state = state.copyWith(isLoading: false, stops: stops);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final lineDetailProvider =
    NotifierProviderFamily<LineDetailNotifier, LineDetailState, LineEntity>(
  () => LineDetailNotifier(),
);
