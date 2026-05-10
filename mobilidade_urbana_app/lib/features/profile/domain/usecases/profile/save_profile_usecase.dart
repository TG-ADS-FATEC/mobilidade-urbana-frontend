import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/profile_entity.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/repository/profile_repository.dart';

class SaveProfileUseCase {
  final ProfileRepository repository;

  const SaveProfileUseCase(this.repository);

  Future<DataState<ProfileEntity>> call({
    required ProfileEntity profile,
  }) async {
    return await repository.saveProfile(
      profile: profile,
    );
  }
}