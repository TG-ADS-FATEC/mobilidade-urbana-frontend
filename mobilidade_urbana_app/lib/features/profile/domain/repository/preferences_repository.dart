

import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences.entity.dart';

abstract class PreferencesRepository {
  Future<DataState<PreferencesEntity>> getPreference();
  Future<DataState<PreferencesEntity>> updatePreference({required PreferencesEntity preferences});
  Future<DataState<PreferencesEntity>> savePreference({required PreferencesEntity preferences});
  Future<DataState<void>> deletePreference();
}