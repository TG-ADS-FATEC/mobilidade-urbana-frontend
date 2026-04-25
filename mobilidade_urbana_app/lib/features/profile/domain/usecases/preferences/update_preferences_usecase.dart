

import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences.entity.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/repository/preferences_repository.dart';

class UpdatePreferencesUsecase {
  final PreferencesRepository repository;

  const UpdatePreferencesUsecase(this.repository);

  Future<DataState<PreferencesEntity>> call({
    required PreferencesEntity preferences,
  }) async {
    return await repository.updatePreference(
      preferences: preferences,
    );
  }
}