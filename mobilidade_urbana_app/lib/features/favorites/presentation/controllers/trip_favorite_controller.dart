import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/di/service_locator.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/trip_favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/repository/trip_favorite_repository.dart';

const _kTripAddressKey = 'trip_favorite_addresses';

class TripFavoriteState {
  final bool isLoading;
  final String? errorMessage;
  final List<TripFavoriteEntity> trips;

  const TripFavoriteState({
    this.isLoading = false,
    this.errorMessage,
    this.trips = const [],
  });

  static const _unset = Object();

  TripFavoriteState copyWith({
    bool? isLoading,
    Object? errorMessage = _unset,
    List<TripFavoriteEntity>? trips,
  }) =>
      TripFavoriteState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: identical(errorMessage, _unset) ? this.errorMessage : errorMessage as String?,
        trips: trips ?? this.trips,
      );
}

class TripFavoriteNotifier extends Notifier<TripFavoriteState> {
  late TripFavoriteRepository _repo;

  @override
  TripFavoriteState build() {
    _repo = sl<TripFavoriteRepository>();
    Future.microtask(loadTrips);
    return const TripFavoriteState();
  }

  Future<Map<String, String>> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_kTripAddressKey);
    if (json == null) return {};
    return (jsonDecode(json) as Map<String, dynamic>).map((k, v) => MapEntry(k, v as String));
  }

  Future<void> _saveAddress(String id, String address) async {
    final map = await _loadAddresses();
    map[id] = address;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTripAddressKey, jsonEncode(map));
  }

  Future<void> _removeAddress(String id) async {
    final map = await _loadAddresses();
    map.remove(id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTripAddressKey, jsonEncode(map));
  }

  TripFavoriteEntity _mergeAddress(TripFavoriteEntity e, Map<String, String> addresses) {
    final addr = e.id != null ? addresses[e.id!] : null;
    if (addr == null) return e;
    return TripFavoriteEntity(
      id: e.id, name: e.name,
      destinationLatitude: e.destinationLatitude,
      destinationLongitude: e.destinationLongitude,
      createdAt: e.createdAt, address: addr,
    );
  }

  Future<void> loadTrips() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final addresses = await _loadAddresses();
    final result = await _repo.getTrips();
    switch (result) {
      case DataSuccess(:final data):
        state = state.copyWith(
          isLoading: false,
          trips: data!.map((t) => _mergeAddress(t, addresses)).toList(),
        );
      case DataFailed(:final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
    }
  }

  Future<bool> addTrip(TripFavoriteEntity trip) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _repo.addTrip(trip);
    switch (result) {
      case DataSuccess(:final data):
        var entity = data!;
        if (trip.address != null && entity.id != null) {
          await _saveAddress(entity.id!, trip.address!);
          entity = TripFavoriteEntity(
            id: entity.id, name: entity.name,
            destinationLatitude: entity.destinationLatitude,
            destinationLongitude: entity.destinationLongitude,
            createdAt: entity.createdAt, address: trip.address,
          );
        }
        state = state.copyWith(isLoading: false, trips: [...state.trips, entity]);
        return true;
      case DataFailed(:final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
    }
  }

  Future<bool> updateTrip(TripFavoriteEntity trip) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _repo.updateTrip(trip);
    switch (result) {
      case DataSuccess(:final data):
        var entity = data!;
        if (trip.id != null) {
          if (trip.address != null) {
            await _saveAddress(trip.id!, trip.address!);
            entity = TripFavoriteEntity(
              id: entity.id, name: entity.name,
              destinationLatitude: entity.destinationLatitude,
              destinationLongitude: entity.destinationLongitude,
              createdAt: entity.createdAt, address: trip.address,
            );
          } else {
            await _removeAddress(trip.id!);
          }
        }
        state = state.copyWith(
          isLoading: false,
          trips: state.trips.map((t) => t.id == entity.id ? entity : t).toList(),
        );
        return true;
      case DataFailed(:final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
    }
  }

  Future<void> deleteTrip(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _repo.deleteTrip(id);
    switch (result) {
      case DataSuccess():
        await _removeAddress(id);
        state = state.copyWith(
          isLoading: false,
          trips: state.trips.where((t) => t.id != id).toList(),
        );
      case DataFailed(:final failure):
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
    }
  }
}

final tripFavoriteProvider = NotifierProvider<TripFavoriteNotifier, TripFavoriteState>(
  () => TripFavoriteNotifier(),
);
