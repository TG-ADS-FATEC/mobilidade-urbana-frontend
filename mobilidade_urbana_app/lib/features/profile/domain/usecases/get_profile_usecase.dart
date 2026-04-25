import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/profile.entity.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/repository/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  const GetProfileUseCase(this.repository);

  Future<DataState<ProfileEntity>> call() async {
    return await repository.getProfile();
  }
}