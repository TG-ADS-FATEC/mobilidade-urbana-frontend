import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/di/service_locator.dart';
import 'package:mobilidade_urbana_app/core/services/device_token_service.dart';
import 'package:mobilidade_urbana_app/core/services/onboarding_service.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences_entity.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/profile_entity.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/preferences/save_preferences_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/profile/save_profile_usecase.dart';

enum OnboardingNavigation { none, back, success }

class OnboardingState {
  final int currentPageIndex;
  final bool isSaving;
  final bool isShowingValidationSnackbar;
  final RoutePreference selectedRoutePreference;
  final Set<TransportType> selectedTransports;
  final bool slowWalkingPace;
  final double walkingDuration;
  final String errorMessage;
  final OnboardingNavigation navigation;

  const OnboardingState({
    this.currentPageIndex = 0,
    this.isSaving = false,
    this.isShowingValidationSnackbar = false,
    this.selectedRoutePreference = RoutePreference.fastest,
    this.selectedTransports = const {},
    this.slowWalkingPace = false,
    this.walkingDuration = 10.0,
    this.errorMessage = '',
    this.navigation = OnboardingNavigation.none,
  });

  bool get canGoNext {
    switch (currentPageIndex) {
      case 0:
        return selectedTransports.isNotEmpty;
      default:
        return true;
    }
  }

  OnboardingState copyWith({
    int? currentPageIndex,
    bool? isSaving,
    bool? isShowingValidationSnackbar,
    RoutePreference? selectedRoutePreference,
    Set<TransportType>? selectedTransports,
    bool? slowWalkingPace,
    double? walkingDuration,
    String? errorMessage,
    OnboardingNavigation? navigation,
  }) {
    return OnboardingState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isSaving: isSaving ?? this.isSaving,
      isShowingValidationSnackbar:
          isShowingValidationSnackbar ?? this.isShowingValidationSnackbar,
      selectedRoutePreference:
          selectedRoutePreference ?? this.selectedRoutePreference,
      selectedTransports: selectedTransports ?? this.selectedTransports,
      slowWalkingPace: slowWalkingPace ?? this.slowWalkingPace,
      walkingDuration: walkingDuration ?? this.walkingDuration,
      errorMessage: errorMessage ?? this.errorMessage,
      navigation: navigation ?? this.navigation,
    );
  }
}

class OnboardingNotifier extends Notifier<OnboardingState> {
  late final SavePreferencesUseCase _savePreferencesUseCase;
  late final SaveProfileUseCase _saveProfileUseCase;
  final pageController = PageController();

  @override
  OnboardingState build() {
    _savePreferencesUseCase = sl<SavePreferencesUseCase>();
    _saveProfileUseCase = sl<SaveProfileUseCase>();

    ref.onDispose(pageController.dispose);
    return const OnboardingState();
  }

  void updatePageIndicator(int index) =>
      state = state.copyWith(currentPageIndex: index);

  void dotNavigationClick(int index) {
    state = state.copyWith(currentPageIndex: index);
    pageController.jumpToPage(index);
  }

  void previousPage() {
    if (state.currentPageIndex == 0) {
      state = state.copyWith(navigation: OnboardingNavigation.back);
      return;
    }
    pageController.animateToPage(
      state.currentPageIndex - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void nextPage() {
    if (!state.canGoNext) {
      _showValidationSnackbar();
      return;
    }
    if (state.currentPageIndex == 2) {
      _saveAndNavigate();
    } else {
      pageController.animateToPage(
        state.currentPageIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipPage() {
    state = state.copyWith(currentPageIndex: 2);
    pageController.jumpToPage(2);
  }

  void toggleTransport(TransportType transport) {
    final updated = Set<TransportType>.from(state.selectedTransports);
    if (updated.contains(transport)) {
      updated.remove(transport);
    } else {
      updated.add(transport);
    }
    state = state.copyWith(selectedTransports: updated);
  }

  bool isTransportSelected(TransportType transport) =>
      state.selectedTransports.contains(transport);

  void updateRoutePreference(RoutePreference value) =>
      state = state.copyWith(selectedRoutePreference: value);

  void updateSlowWalkingPace(bool value) =>
      state = state.copyWith(slowWalkingPace: value);

  void updateWalkingDuration(double value) =>
      state = state.copyWith(walkingDuration: value);

  void clearNavigation() =>
      state = state.copyWith(navigation: OnboardingNavigation.none);

  Future<void> _saveAndNavigate() async {
    state = state.copyWith(isSaving: true);

    final deviceToken = await DeviceTokenService.get();

    final profile = ProfileEntity(deviceId: deviceToken, createdAt: DateTime.now(), updatedAt: DateTime.now());

    final preferences = PreferencesEntity(
      transportTypes: state.selectedTransports.toList(),
      routePreference: state.selectedRoutePreference,
      slowPace: state.slowWalkingPace,
      maxWalkingTime: state.walkingDuration.toInt(),
      updatedAt: DateTime.now(),
      deviceToken: deviceToken,
    );


    final profileResult = await _saveProfileUseCase(profile: profile);
    switch (profileResult) {
      case DataSuccess(:final data):
        final preferencesResult = await _savePreferencesUseCase(preferences: preferences);
        switch (preferencesResult) {
          case DataSuccess():
            await OnboardingService.setComplete();
            state = state.copyWith(isSaving: false, navigation: OnboardingNavigation.success);
          case DataFailed(:final failure):
            debugPrint('[Onboarding] Preferences falhou: ${failure.message}');
            state = state.copyWith(isSaving: false, errorMessage: failure.message);
        }
      case DataFailed(:final failure):
        state = state.copyWith(isSaving: false, errorMessage: failure.message);
    }

  }

  void _showValidationSnackbar() {
    if (state.isShowingValidationSnackbar) return;
    state = state.copyWith(isShowingValidationSnackbar: true);
    Future.delayed(
      const Duration(seconds: 2),
      () => state = state.copyWith(isShowingValidationSnackbar: false),
    );
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
  () => OnboardingNotifier(),
);
