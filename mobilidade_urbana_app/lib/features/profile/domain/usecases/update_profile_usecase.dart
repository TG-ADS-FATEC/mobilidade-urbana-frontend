import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/profile.entity.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/repository/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  const UpdateProfileUseCase(this.repository);

  Future<DataState<ProfileEntity>> call({
    required String deviceToken,
    required ProfileEntity profile,
  }) async {
    return await repository.updateProfile(
      deviceToken: deviceToken,
      profile: profile,
    );
  }
}