import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/services/device_token_service.dart';
import 'package:mobilidade_urbana_app/core/services/onboarding_service.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences.entity.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/preferences/save_preferences_usecase.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  final SavePreferencesUseCase _savePreferencesUseCase;
  OnBoardingController(this._savePreferencesUseCase);

  final pageController = PageController();
  final currentPageIndex = 0.obs;
  final isSaving = false.obs;
  final isShowingValidationSnackbar = false.obs;

  final selectedRoutePreference = RoutePreference.fastest.obs;
  final selectedTransports = <TransportType>{}.obs;
  final slowWalkingPace = false.obs;
  final walkingDuration = 10.0.obs;

  bool get canGoNext {
    switch (currentPageIndex.value) {
      case 0: return selectedTransports.isNotEmpty;
      case 1: return true;
      case 2: return true;
      default: return false;
    }
  }

  void updatePageIndicator(int index) => currentPageIndex.value = index;

  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  void previousPage() {
    if (currentPageIndex.value == 0) {
      Get.back();
      return;
    }
    pageController.animateToPage(
      currentPageIndex.value - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void nextPage() {
    if (!canGoNext) {
      _showValidationSnackbar();
      return;
    }
    if (currentPageIndex.value == 2) {
      _saveAndNavigate();
    } else {
      pageController.animateToPage(
        currentPageIndex.value + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }

  void toggleTransport(TransportType transport) {
    if (selectedTransports.contains(transport)) {
      selectedTransports.remove(transport);
    } else {
      selectedTransports.add(transport);
    }
  }

  bool isTransportSelected(TransportType transport) =>
      selectedTransports.contains(transport);

  void updateRoutePreference(RoutePreference value) =>
      selectedRoutePreference.value = value;

  void updateSlowWalkingPace(bool value) => slowWalkingPace.value = value;

  void updateWalkingDuration(double value) => walkingDuration.value = value;


  Future<void> _saveAndNavigate() async {
    isSaving.value = true;
    final deviceToken = await DeviceTokenService.get();

    final preferences = PreferencesEntity(
      transportTypes: selectedTransports.toList(),
      routePreference: selectedRoutePreference.value,
      slowPace: slowWalkingPace.value,
      maxWalkingTime: walkingDuration.value.toInt(),
      updatedAt: DateTime.now(),
      deviceToken: deviceToken,
    );

    final result = await _savePreferencesUseCase(preferences: preferences);

    isSaving.value = false;

    switch (result) {
      case DataSuccess():
        await OnboardingService.setComplete();
        Get.offAllNamed('/onboarding-success');

      case DataFailed():
        Get.snackbar(
          'Erro',
          result.failure.message ?? 'Não foi possível salvar suas preferências',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
    }
  }

  void _showValidationSnackbar() {
    if (isShowingValidationSnackbar.value) return;
    isShowingValidationSnackbar.value = true;

    final messages = {
      0: 'Selecione pelo menos um meio de transporte.',
      1: 'Selecione uma preferência de rota.',
    };

    Get.snackbar(
      'Atenção',
      messages[currentPageIndex.value] ??
          'Preencha as informações antes de continuar.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );

    Future.delayed(
      const Duration(seconds: 2),
          () => isShowingValidationSnackbar.value = false,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}