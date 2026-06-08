import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/core/di/service_locator.dart';
import 'package:mobilidade_urbana_app/features/lines/data/data_sources/stop_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/stop_entity.dart';

class LineDetailState {
  /// Todos os trips do itinerário (cada trip = uma lista de paradas).
  final List<List<StopEntity>> trips;

  /// Índice do trip atualmente exibido.
  final int selectedTrip;

  final bool isLoading;
  final String? errorMessage;

  const LineDetailState({
    this.trips = const [],
    this.selectedTrip = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Paradas do trip selecionado.
  List<StopEntity> get stops =>
      trips.isNotEmpty ? trips[selectedTrip] : const [];

  /// Há mais de um sentido disponível.
  bool get hasMultipleDirections => trips.length > 1;

  static const _unset = Object();

  LineDetailState copyWith({
    List<List<StopEntity>>? trips,
    int? selectedTrip,
    bool? isLoading,
    Object? errorMessage = _unset,
  }) =>
      LineDetailState(
        trips: trips ?? this.trips,
        selectedTrip: selectedTrip ?? this.selectedTrip,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: identical(errorMessage, _unset)
            ? this.errorMessage
            : errorMessage as String?,
      );
}

class LineDetailNotifier extends FamilyNotifier<LineDetailState, LineEntity> {
  late StopRemoteDatasource _datasource;

  @override
  LineDetailState build(LineEntity line) {
    if (line.type != LineType.bus) return const LineDetailState();

    _datasource = sl<StopRemoteDatasource>();
    Future.microtask(_loadItinerary);
    return const LineDetailState(isLoading: true);
  }

  Future<void> _loadItinerary() async {
    final routeId = arg.id;
    if (routeId == null) {
      state = state.copyWith(isLoading: false, errorMessage: 'ID da linha não encontrado');
      return;
    }
    try {
      final trips = await _datasource.getItinerary(routeId);
      state = state.copyWith(isLoading: false, trips: trips, errorMessage: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void switchDirection() {
    if (!state.hasMultipleDirections) return;
    final next = (state.selectedTrip + 1) % state.trips.length;
    state = state.copyWith(selectedTrip: next);
  }
}

final lineDetailProvider =
    NotifierProviderFamily<LineDetailNotifier, LineDetailState, LineEntity>(
  () => LineDetailNotifier(),
);
