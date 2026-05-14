import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/di/service_locator.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences_entity.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/preferences/get_preferences_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/preferences/save_preferences_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/preferences/update_preferences_usecase.dart';

class PreferencesState {
  final PreferencesEntity? preferences;
  final bool isLoading;
  final bool isSaved;
  final String errorMessage;

  const PreferencesState({
    this.preferences,
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage = '',
  });

  PreferencesState copyWith({
    PreferencesEntity? preferences,
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
  }) {
    return PreferencesState(
      preferences: preferences ?? this.preferences,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class PreferencesNotifier extends Notifier<PreferencesState> {
  late final GetPreferencesUsecase _getPreferencesUsecase;
  late final UpdatePreferencesUsecase _updatePreferencesUsecase;
  late final SavePreferencesUseCase _savePreferencesUseCase;

  @override
  PreferencesState build() {
    _getPreferencesUsecase = sl<GetPreferencesUsecase>();
    _updatePreferencesUsecase = sl<UpdatePreferencesUsecase>();
    _savePreferencesUseCase = sl<SavePreferencesUseCase>();
    loadPreferences();
    return const PreferencesState();
  }

  Future<void> loadPreferences() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      final result = await _getPreferencesUsecase();
      switch (result) {
        case DataSuccess(:final data):
          state = state.copyWith(preferences: data, isLoading: false);
        case DataFailed(:final failure):
          state = state.copyWith(errorMessage: failure.message, isLoading: false);
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updatePreferences(PreferencesEntity updatedPreferences) async {
    if (state.preferences == null) return;
    try {
      state = state.copyWith(isLoading: true, isSaved: false, errorMessage: '');

      final updated = state.preferences!.copyWith(
        transportTypes: updatedPreferences.transportTypes,
        routePreference: updatedPreferences.routePreference,
        slowPace: updatedPreferences.slowPace,
        maxWalkingTime: updatedPreferences.maxWalkingTime,
        updatedAt: DateTime.now(),
      );

      final result = await _updatePreferencesUsecase(preferences: updated);

      switch (result) {
        case DataSuccess(:final data):
          state = state.copyWith(preferences: data, isLoading: false, isSaved: true);
          Future.delayed(
            const Duration(seconds: 2),
            () => state = state.copyWith(isSaved: false),
          );
        case DataFailed(:final failure):
          state = state.copyWith(errorMessage: failure.message, isLoading: false);
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> savePreferences(PreferencesEntity newPreferences) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      final result = await _savePreferencesUseCase(preferences: newPreferences);
      switch (result) {
        case DataSuccess(:final data):
          state = state.copyWith(preferences: data, isLoading: false, isSaved: true);
          Future.delayed(
            const Duration(seconds: 2),
            () => state = state.copyWith(isSaved: false),
          );
        case DataFailed(:final failure):
          state = state.copyWith(errorMessage: failure.message, isLoading: false);
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final preferencesControllerProvider =
    NotifierProvider<PreferencesNotifier, PreferencesState>(
  () => PreferencesNotifier(),
);
