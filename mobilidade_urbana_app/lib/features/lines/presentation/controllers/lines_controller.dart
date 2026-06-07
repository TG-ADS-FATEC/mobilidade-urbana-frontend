import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/di/service_locator.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/usecases/get_lines_usecase.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/usecases/get_metro_lines_usecase.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/usecases/get_train_lines_usecase.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/usecases/search_lines_usecase.dart';

class LinesState {
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final List<LineEntity> busLines;
  final List<LineEntity> metroLines;
  final List<LineEntity> trainLines;
  final int currentPage;
  final bool hasNext;
  final String query;

  LinesState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.busLines = const [],
    this.metroLines = const [],
    this.trainLines = const [],
    this.currentPage = 0,
    this.hasNext = false,
    this.query = '',
  });

  bool get isSearching => query.isNotEmpty;

  /// Todas as linhas combinadas (para a aba "Todos" e busca)
  List<LineEntity> get allLines => [...busLines, ...metroLines, ...trainLines];

  static const _unset = Object();

  LinesState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    Object? errorMessage = _unset,
    List<LineEntity>? busLines,
    List<LineEntity>? metroLines,
    List<LineEntity>? trainLines,
    int? currentPage,
    bool? hasNext,
    String? query,
  }) {
    return LinesState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: identical(errorMessage, _unset) ? this.errorMessage : errorMessage as String?,
      busLines: busLines ?? this.busLines,
      metroLines: metroLines ?? this.metroLines,
      trainLines: trainLines ?? this.trainLines,
      currentPage: currentPage ?? this.currentPage,
      hasNext: hasNext ?? this.hasNext,
      query: query ?? this.query,
    );
  }
}

class LinesNotifier extends Notifier<LinesState> {
  late final GetLinesUsecase _getLinesUsecase;
  late final GetMetroLinesUsecase _getMetroLinesUsecase;
  late final GetTrainLinesUsecase _getTrainLinesUsecase;
  late final SearchLinesUsecase _searchLinesUsecase;

  static const _pageSize = 20;
  static const _debounceDuration = Duration(milliseconds: 400);

  Timer? _debounce;

  @override
  LinesState build() {
    _getLinesUsecase = sl<GetLinesUsecase>();
    _getMetroLinesUsecase = sl<GetMetroLinesUsecase>();
    _getTrainLinesUsecase = sl<GetTrainLinesUsecase>();
    _searchLinesUsecase = sl<SearchLinesUsecase>();
    ref.onDispose(() => _debounce?.cancel());
    Future.microtask(_loadAll);
    return LinesState();
  }

  /// Carrega ônibus (API), metrô e trem (local) em paralelo.
  Future<void> _loadAll() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final results = await Future.wait([
      _getLinesUsecase(page: 0, size: _pageSize),
      _getMetroLinesUsecase(),
      _getTrainLinesUsecase(),
    ]);

    final busResult   = results[0] as DataState<({List<LineEntity> items, bool hasNext})>;
    final metroResult = results[1] as DataState<List<LineEntity>>;
    final trainResult = results[2] as DataState<List<LineEntity>>;

    String? error;
    List<LineEntity> bus   = state.busLines;
    List<LineEntity> metro = state.metroLines;
    List<LineEntity> train = state.trainLines;
    bool hasNext = false;

    switch (busResult) {
      case DataSuccess(:final data):
        bus = data!.items;
        hasNext = data.hasNext;
      case DataFailed(:final failure):
        error = failure.message;
    }
    if (metroResult case DataSuccess(:final data)) metro = data ?? [];
    if (trainResult case DataSuccess(:final data)) train = data ?? [];

    state = state.copyWith(
      isLoading: false,
      busLines: bus,
      metroLines: metro,
      trainLines: train,
      currentPage: 0,
      hasNext: hasNext,
      errorMessage: error,
    );
  }

  Future<void> loadLines() => _loadAll();

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasNext || state.isSearching) return;

    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.currentPage + 1;
      final result = await _getLinesUsecase(page: nextPage, size: _pageSize);
      switch (result) {
        case DataSuccess(:final data):
          state = state.copyWith(
            isLoadingMore: false,
            busLines: [...state.busLines, ...data!.items],
            currentPage: nextPage,
            hasNext: data.hasNext,
          );
        case DataFailed(:final failure):
          state = state.copyWith(isLoadingMore: false, errorMessage: failure.message);
      }
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, errorMessage: e.toString());
    }
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();
    state = state.copyWith(query: query);

    if (query.isEmpty) {
      _loadAll();
      return;
    }

    _debounce = Timer(_debounceDuration, () => _search(query));
  }

  Future<void> _search(String query) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await _searchLinesUsecase(query);
      switch (result) {
        case DataSuccess(:final data):
          state = state.copyWith(
            isLoading: false,
            busLines: data ?? [],
            metroLines: const [],
            trainLines: const [],
            hasNext: false,
            errorMessage: null,
          );
        case DataFailed(:final failure):
          state = state.copyWith(isLoading: false, errorMessage: failure.message);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final linesControllerProvider = NotifierProvider<LinesNotifier, LinesState>(
  () => LinesNotifier(),
);
