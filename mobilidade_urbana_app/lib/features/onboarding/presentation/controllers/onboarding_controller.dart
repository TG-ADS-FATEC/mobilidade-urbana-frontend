import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/features/onboarding/data/models/onboarding_model.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/screens/success_screen.dart';
import 'package:mobilidade_urbana_app/utils/device/device_register_service.dart';
import 'package:mobilidade_urbana_app/utils/device/device_token_service.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  final pageController = PageController();
  final currentPageIndex = 0.obs;

  final selectedRoutePreference = 'Mais rápida'.obs;
  final transportPreferences = <String, bool>{
    'Ônibus': false,
    'Trem': false,
    'Metrô': false,
  }.obs;
  final slowWalkingPace = false.obs;
  final walkingDuration = 10.0.obs;
  final isShowingValidationSnackbar = false.obs;

  final isSaving = false.obs;
  String _deviceToken = '';


  @override
  void onInit() async {
    super.onInit();
    _deviceToken = await DeviceTokenService.get();
  }

  bool get canGoNext {
    switch (currentPageIndex.value) {
      case 0: return transportPreferences.values.any((v) => v);
      case 1: return selectedRoutePreference.value.isNotEmpty;
      case 2: return true;
      default: return false;
    }
  }

  void updatePageIndicator(index) => currentPageIndex.value = index;

  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  void toggleTransport(String transport, bool value) {
    transportPreferences[transport] = value;
    transportPreferences.refresh();
  }

  bool isTransportEnabled(String transport) =>
      transportPreferences[transport] ?? false;

  void updateRoutePreference(String value) =>
      selectedRoutePreference.value = value;

  void updateSlowWalkingPace(bool value) => slowWalkingPace.value = value;

  void updateWalkingDuration(double value) => walkingDuration.value = value;

  void previousPage() {
    if (currentPageIndex.value == 0) { Get.back(); return; }
    pageController.animateToPage(
      currentPageIndex.value - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }

  void nextPage() {
    if (!canGoNext) { showValidationSnackbar(); return; }
    if (currentPageIndex.value == 2) {
      _saveAndNavigate(); // ← NOVO
    } else {
      pageController.animateToPage(
        currentPageIndex.value + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _saveAndNavigate() async {
    isSaving.value = true;

    final model = OnboardingModel(
      deviceToken: _deviceToken,
      transportPreferences: transportPreferences.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList(),
      selectedRoutePreference: selectedRoutePreference.value,
      slowWalkingPace: slowWalkingPace.value,
      walkingDuration: walkingDuration.value,
      isCompleted: true,
    );



    await OnboardingHiveService.save(model);
    Get.to(() => const OnboardingSuccessScreen());
    await DeviceRegisterService.register();

    isSaving.value = false;
  }

  void showValidationSnackbar() {
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
    Future.delayed(const Duration(seconds: 2), () {
      isShowingValidationSnackbar.value = false;
    });
  }
}