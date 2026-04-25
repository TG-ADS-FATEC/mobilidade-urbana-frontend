
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences.entity.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/repository/preferences_repository.dart';

class GetPreferencesUsecase {
  final PreferencesRepository repository;

  const GetPreferencesUsecase(this.repository);

  Future<DataState<PreferencesEntity>> call() async {
    return await repository.getPreference();
  }
}