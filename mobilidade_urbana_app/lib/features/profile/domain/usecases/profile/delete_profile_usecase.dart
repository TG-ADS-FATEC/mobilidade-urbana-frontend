
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/repository/profile_repository.dart';

class DeleteProfileUseCase {
  final ProfileRepository repository;
  const DeleteProfileUseCase(this.repository);

  Future<DataState<void>> call() async {
    return await repository.deleteProfile();
  }
}