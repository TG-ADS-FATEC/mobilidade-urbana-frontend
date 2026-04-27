

import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/widgets/confirm_dialog.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/profile.entity.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/profile/delete_profile_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/profile/get_profile_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/profile/update_profile_usecase.dart';

class ProfileController extends GetxController {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final DeleteProfileUseCase _deleteProfileUseCase;

  ProfileController(this._getProfileUseCase, this._updateProfileUseCase, this._deleteProfileUseCase);

  final Rx<ProfileEntity?> profile = Rx<ProfileEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _getProfileUseCase();

      switch (result) {
        case DataSuccess(:final data):
          profile.value = data;
        case DataFailed(:final failure):
          errorMessage.value = failure.message;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(ProfileEntity updatedProfile) async {
    if (profile.value == null) return;

    try {
      isLoading.value =  true;
      errorMessage.value = '';

      final updated = profile.value!.copyWith(
        name: updatedProfile.name,
        avatarPath: updatedProfile.avatarPath,
      );

      final result = await _updateProfileUseCase(
        profile: updated,
      );

      switch (result) {
        case DataSuccess(:final data):
          profile.value = data;
        case DataFailed(:final failure):
          errorMessage.value = failure.message;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProfile() async {

    final confirmed = await ConfirmDialog.show(
      title: 'Excluir conta',
      message: 'Tem certeza? Essa ação não pode ser desfeita.',
      confirmText: 'Excluir',
      isDangerous: true,
    );

    if (confirmed != true) return; //

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _deleteProfileUseCase();

      switch (result) {
        case DataSuccess(:final data):
          profile.value = null;
          Get.offAllNamed('/welcome');
        case DataFailed(:final failure):
          errorMessage.value = failure.message;
      }
    } finally {
      isLoading.value = false;
    }
  }

}