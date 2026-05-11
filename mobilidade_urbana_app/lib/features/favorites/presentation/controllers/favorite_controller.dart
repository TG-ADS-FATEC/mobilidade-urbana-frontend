
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/di/service_locator.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/usecases/add_favorites_usecase.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/usecases/delete_favorite_usecase.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/usecases/update_favorite_usecase.dart';

class FavoriteState {
  final bool isLoading;
  final String? errorMessage;
  final List<FavoriteEntity> favorites;

  FavoriteState({
    this.isLoading = false,
    this.errorMessage,
    this.favorites = const [],
  });

  FavoriteState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<FavoriteEntity>? favorites,
  }) {
    return FavoriteState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      favorites: favorites ?? this.favorites,
    );
  }
}

class FavoriteNotifier extends Notifier<FavoriteState> {
  late final GetFavoritesUsecase _getFavoritesUsecase;
  late final AddFavoritesUsecase _addFavoritesUsecase;
  late final UpdateFavoriteUsecase _updateFavoriteUsecase;
  late final DeleteFavoriteUsecase _deleteFavoriteUsecase;

  @override
  FavoriteState build() {
    _addFavoritesUsecase = sl<AddFavoritesUsecase>();
    _getFavoritesUsecase = sl<GetFavoritesUsecase>();
    _updateFavoriteUsecase = sl<UpdateFavoriteUsecase>();
    _deleteFavoriteUsecase = sl<DeleteFavoriteUsecase>();

    return FavoriteState();
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getFavoritesUsecase();
    switch (result) {
      case DataSuccess(:final data):
        state = state.copyWith(isLoading: false, favorites: data);
      case DataFailed(:final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
    }
  }

  Future<void> addFavorite(FavoriteEntity favorite) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _addFavoritesUsecase(favorite);
    switch(result) {
      case DataSuccess(:final data):
        state = state.copyWith(isLoading: false, favorites: [...state.favorites, data]);
      case DataFailed(:final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
    }
  }

  Future<void> updateFavorite(FavoriteEntity favorite) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _updateFavoriteUsecase(favorite: favorite);
    switch(result) {
      case DataSuccess(:final data):
        final updatedFavorites = state.favorites.map((f) => f.favoriteId == data.favoriteId ? data : f).toList();
        state = state.copyWith(isLoading: false, favorites: updatedFavorites);
      case DataFailed(:final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
    }
  }

  Future<void> deleteFavorite(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _deleteFavoriteUsecase(id);
    switch(result) {
      case DataSuccess():
        final updatedFavorites = state.favorites.where((f) => f.favoriteId != id).toList();
        state = state.copyWith(isLoading: false, favorites: updatedFavorites);
      case DataFailed(:final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
    }
  }
}
