

import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/repository/preferences_repository.dart';

class DeletePreferencesUsecase {
  final PreferencesRepository repository;
  const DeletePreferencesUsecase(this.repository);

  Future<DataState<void>> call() async {
    return await repository.deletePreference();
  }
}