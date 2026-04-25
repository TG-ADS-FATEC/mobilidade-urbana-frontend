import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/profile.entity.dart';

abstract class ProfileRepository {
  Future<DataState<ProfileEntity>> getProfile();
  Future<DataState<ProfileEntity>> updateProfile({required ProfileEntity profile});
  Future<DataState<void>> deleteProfile();
}