
import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:mobilidade_urbana_app/features/onboarding/data/datasources/onboarding_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/controllers/onboarding_controller.dart';

class OnboadingBinding extends Bindings{
  @override
  void dependencies() {

      Get.lazyPut<OnboardingLocalDatasource>(
            () => OnboardingLocalDatasource(),
      );

      Get.lazyPut<OnboardingRemoteDatasource>(
            () => OnboardingRemoteDatasource(),
      );

      Get.lazyPut<OnboardingRepository>(
            () => OnboardingRepository(
          Get.find<OnboardingLocalDatasource>(),
          Get.find<OnboardingRemoteDatasource>(),
        ),
      );

      Get.lazyPut<OnBoardingController>(
            () => OnBoardingController(
          Get.find<OnboardingRepository>(),
        ),
      );
  }
}