import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/di/service_locator.dart';
import 'package:mobilidade_urbana_app/core/services/device_token_service.dart';
import 'package:mobilidade_urbana_app/core/services/onboarding_service.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/profile_entity.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/profile/delete_profile_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/profile/get_profile_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/profile/update_profile_usecase.dart';

class ProfileState {
  final ProfileEntity? profile;
  final bool isLoading;
  final String errorMessage;
  final bool navigateToWelcome;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.errorMessage = '',
    this.navigateToWelcome = false,
  });

  ProfileState copyWith({
    ProfileEntity? profile,
    bool? isLoading,
    String? errorMessage,
    bool? navigateToWelcome,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      navigateToWelcome: navigateToWelcome ?? this.navigateToWelcome,
    );
  }
}

class ProfileNotifier extends Notifier<ProfileState> {
  late final GetProfileUseCase _getProfileUseCase;
  late final UpdateProfileUseCase _updateProfileUseCase;
  late final DeleteProfileUseCase _deleteProfileUseCase;

  @override
  ProfileState build() {
    _getProfileUseCase = sl<GetProfileUseCase>();
    _updateProfileUseCase = sl<UpdateProfileUseCase>();
    _deleteProfileUseCase = sl<DeleteProfileUseCase>();
    loadProfile();
    return const ProfileState();
  }

  Future<void> loadProfile() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      final result = await _getProfileUseCase();
      switch (result) {
        case DataSuccess(:final data):
          state = state.copyWith(profile: data, isLoading: false);
        case DataFailed(:final failure):
          state = state.copyWith(errorMessage: failure.message, isLoading: false);
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updateProfile(ProfileEntity updatedProfile) async {
    if (state.profile == null) return;
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      final updated = state.profile!.copyWith(
        name: updatedProfile.name,
        avatarPath: updatedProfile.avatarPath,
      );
      final result = await _updateProfileUseCase(profile: updated);
      switch (result) {
        case DataSuccess(:final data):
          state = state.copyWith(profile: data, isLoading: false);
        case DataFailed(:final failure):
          state = state.copyWith(errorMessage: failure.message, isLoading: false);
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> deleteProfile() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      final result = await _deleteProfileUseCase();
      switch (result) {
        case DataSuccess():
          await DeviceTokenService.deleteJwt();
          await DeviceTokenService.delete();
          await OnboardingService.clear();
          state = state.copyWith(
            profile: null,
            isLoading: false,
            navigateToWelcome: true,
          );
        case DataFailed(:final failure):
          state = state.copyWith(errorMessage: failure.message, isLoading: false);
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearNavigation() =>
      state = state.copyWith(navigateToWelcome: false);
}

final profileControllerProvider =
    NotifierProvider<ProfileNotifier, ProfileState>(
  () => ProfileNotifier(),
);
