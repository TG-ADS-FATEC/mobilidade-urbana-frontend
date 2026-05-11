
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/di/service_locator.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/usecases/add_favorites_usecase.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/usecases/delete_favorite_usecase.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/usecases/update_favorite_usecase.dart';

const _kUsageKey = 'favorite_usage_counts';
const _kAddressKey = 'favorite_addresses';

class FavoriteState {
  final bool isLoading;
  final String? errorMessage;
  final List<FavoriteEntity> favorites;
  final Map<String, int> usageCounts;

  FavoriteState({
    this.isLoading = false,
    this.errorMessage,
    this.favorites = const [],
    this.usageCounts = const {},
  });

  FavoriteState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<FavoriteEntity>? favorites,
    Map<String, int>? usageCounts,
  }) {
    return FavoriteState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      favorites: favorites ?? this.favorites,
      usageCounts: usageCounts ?? this.usageCounts,
    );
  }

  List<FavoriteEntity> get topFavorites {
    final sorted = [...favorites];
    sorted.sort((a, b) {
      final aCount = usageCounts[a.favoriteId ?? ''] ?? 0;
      final bCount = usageCounts[b.favoriteId ?? ''] ?? 0;
      return bCount.compareTo(aCount);
    });
    return sorted.take(3).toList();
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
    Future.microtask(loadFavorites);
    return FavoriteState();
  }

  // ── Helpers de persistência local ──────────────────────────────────────────

  Future<Map<String, String>> _loadLocalAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_kAddressKey);
    if (json == null) return {};
    return (jsonDecode(json) as Map<String, dynamic>).map((k, v) => MapEntry(k, v as String));
  }

  Future<void> _saveLocalAddress(String favoriteId, String address) async {
    final addresses = await _loadLocalAddresses();
    addresses[favoriteId] = address;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAddressKey, jsonEncode(addresses));
  }

  Future<void> _removeLocalAddress(String favoriteId) async {
    final addresses = await _loadLocalAddresses();
    addresses.remove(favoriteId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAddressKey, jsonEncode(addresses));
  }

  // Combina a entity retornada pela API com o endereço salvo localmente.
  FavoriteEntity _merge(FavoriteEntity entity, Map<String, String> localAddresses) {
    final addr = entity.favoriteId != null ? localAddresses[entity.favoriteId!] : null;
    if (addr == null) return entity;
    return FavoriteEntity(
      favoriteId: entity.favoriteId,
      favoriteName: entity.favoriteName,
      address: addr,
      createdAt: entity.createdAt,
    );
  }

  // ── CRUD ───────────────────────────────────────────────────────────────────

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final prefs = await SharedPreferences.getInstance();

    final countsJson = prefs.getString(_kUsageKey);
    final usageCounts = countsJson != null
        ? (jsonDecode(countsJson) as Map<String, dynamic>).map((k, v) => MapEntry(k, v as int))
        : <String, int>{};

    final localAddresses = await _loadLocalAddresses();

    final result = await _getFavoritesUsecase();
    switch (result) {
      case DataSuccess(:final data):
        final merged = data.map((f) => _merge(f, localAddresses)).toList();
        state = state.copyWith(isLoading: false, favorites: merged, usageCounts: usageCounts);
      case DataFailed(:final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message, usageCounts: usageCounts);
    }
  }

  Future<bool> addFavorite(FavoriteEntity favorite) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _addFavoritesUsecase(favorite);
    switch (result) {
      case DataSuccess(:final data):
        var entityToAdd = data;
        if (favorite.address != null && data.favoriteId != null) {
          await _saveLocalAddress(data.favoriteId!, favorite.address!);
          entityToAdd = FavoriteEntity(
            favoriteId: data.favoriteId,
            favoriteName: data.favoriteName,
            address: favorite.address,
            createdAt: data.createdAt,
          );
        }
        state = state.copyWith(isLoading: false, favorites: [...state.favorites, entityToAdd]);
        return true;
      case DataFailed(:final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
    }
  }

  Future<bool> updateFavorite(FavoriteEntity favorite) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _updateFavoriteUsecase(favorite: favorite);
    switch (result) {
      case DataSuccess(:final data):
        var updatedEntity = data;
        if (favorite.favoriteId != null) {
          if (favorite.address != null) {
            await _saveLocalAddress(favorite.favoriteId!, favorite.address!);
            updatedEntity = FavoriteEntity(
              favoriteId: data.favoriteId,
              favoriteName: data.favoriteName,
              address: favorite.address,
              createdAt: data.createdAt,
            );
          } else {
            await _removeLocalAddress(favorite.favoriteId!);
          }
        }
        final updatedFavorites = state.favorites
            .map((f) => f.favoriteId == updatedEntity.favoriteId ? updatedEntity : f)
            .toList();
        state = state.copyWith(isLoading: false, favorites: updatedFavorites);
        return true;
      case DataFailed(:final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
    }
  }

  Future<void> deleteFavorite(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _deleteFavoriteUsecase(id);
    switch (result) {
      case DataSuccess():
        final updatedFavorites = state.favorites.where((f) => f.favoriteId != id).toList();
        final updatedCounts = Map<String, int>.from(state.usageCounts)..remove(id);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_kUsageKey, jsonEncode(updatedCounts));
        await _removeLocalAddress(id);
        state = state.copyWith(isLoading: false, favorites: updatedFavorites, usageCounts: updatedCounts);
      case DataFailed(:final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
    }
  }

  Future<void> incrementUsage(String id) async {
    final updatedCounts = Map<String, int>.from(state.usageCounts);
    updatedCounts[id] = (updatedCounts[id] ?? 0) + 1;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUsageKey, jsonEncode(updatedCounts));
    state = state.copyWith(usageCounts: updatedCounts);
  }
}

final favoriteControllerProvider = NotifierProvider<FavoriteNotifier, FavoriteState>(
  () => FavoriteNotifier(),
);
