import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/di/service_locator.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/usecases/get_lines_usecase.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/usecases/search_lines_usecase.dart';

class LinesState {
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final List<LineEntity> lines;
  final int currentPage;
  final bool hasNext;
  final String query;

  LinesState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.lines = const [],
    this.currentPage = 0,
    this.hasNext = false,
    this.query = '',
  });

  bool get isSearching => query.isNotEmpty;

  static const _unset = Object();

  LinesState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    Object? errorMessage = _unset,
    List<LineEntity>? lines,
    int? currentPage,
    bool? hasNext,
    String? query,
  }) {
    return LinesState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: identical(errorMessage, _unset) ? this.errorMessage : errorMessage as String?,
      lines: lines ?? this.lines,
      currentPage: currentPage ?? this.currentPage,
      hasNext: hasNext ?? this.hasNext,
      query: query ?? this.query,
    );
  }
}

class LinesNotifier extends Notifier<LinesState> {
  late final GetLinesUsecase _getLinesUsecase;
  late final SearchLinesUsecase _searchLinesUsecase;

  static const _pageSize = 20;
  static const _debounceDuration = Duration(milliseconds: 400);

  Timer? _debounce;

  @override
  LinesState build() {
    _getLinesUsecase = sl<GetLinesUsecase>();
    _searchLinesUsecase = sl<SearchLinesUsecase>();
    ref.onDispose(() => _debounce?.cancel());
    Future.microtask(loadLines);
    return LinesState();
  }

  Future<void> loadLines() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await _getLinesUsecase(page: 0, size: _pageSize);
      switch (result) {
        case DataSuccess(:final data):
          state = state.copyWith(
            isLoading: false,
            lines: data!.items,
            currentPage: 0,
            hasNext: data.hasNext,
            errorMessage: null,
          );
        case DataFailed(:final failure):
          state = state.copyWith(isLoading: false, errorMessage: failure.message);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

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
            lines: [...state.lines, ...data!.items],
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
      loadLines();
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
            lines: data ?? [],
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
