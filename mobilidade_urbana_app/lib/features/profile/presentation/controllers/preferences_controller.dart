import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences.entity.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/preferences/get_preferences_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/preferences/save_preferences_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/preferences/update_preferences_usecase.dart';

class PreferencesController extends GetxController {
  final GetPreferencesUsecase _getPreferencesUsecase;
  final UpdatePreferencesUsecase _updatePreferencesUsecase;
  final SavePreferencesUseCase _savePreferencesUseCase;

  PreferencesController(
      this._getPreferencesUsecase,
      this._updatePreferencesUsecase,
      this._savePreferencesUseCase,
      );

  final Rx<PreferencesEntity?> preferences = Rx<PreferencesEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isSaved = false.obs;
  final RxString errorMessage = ''.obs;

  Worker? _savedFeedbackWorker;

  @override
  void onInit() {
    super.onInit();
    loadPreferences();
  }

  @override
  void onClose() {
    _savedFeedbackWorker?.dispose();
    super.onClose();
  }

  Future<void> loadPreferences() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _getPreferencesUsecase();

      switch (result) {
        case DataSuccess(:final data):
          preferences.value = data;
        case DataFailed(:final failure):
          errorMessage.value = failure.message;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePreferences(PreferencesEntity updatedPreferences) async {
    if (preferences.value == null) return;

    try {
      isLoading.value = true;
      isSaved.value = false;
      errorMessage.value = '';

      final updated = preferences.value!.copyWith(
        transportTypes: updatedPreferences.transportTypes,
        routePreference: updatedPreferences.routePreference,
        slowPace: updatedPreferences.slowPace,
        maxWalkingTime: updatedPreferences.maxWalkingTime,
        updatedAt: DateTime.now(),
      );

      final result = await _updatePreferencesUsecase(preferences: updated);

      switch (result) {
        case DataSuccess(:final data):
          preferences.value = data;
          isSaved.value = true;
          // volta para false após 2 segundos
          Future.delayed(const Duration(seconds: 2), () => isSaved.value = false);
        case DataFailed(:final failure):
          errorMessage.value = failure.message;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> savePreferences(PreferencesEntity newPreferences) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _savePreferencesUseCase(preferences: newPreferences);

      switch (result) {
        case DataSuccess(:final data):
          preferences.value = data;
          isSaved.value = true;
          Future.delayed(const Duration(seconds: 2), () => isSaved.value = false);
        case DataFailed(:final failure):
          errorMessage.value = failure.message;
      }
    } finally {
      isLoading.value = false;
    }
  }
}