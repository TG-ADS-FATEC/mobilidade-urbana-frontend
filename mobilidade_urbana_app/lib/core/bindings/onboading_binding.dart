import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:mobilidade_urbana_app/features/profile/data/data_sources/preferences_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/profile/data/repository/preferences_repository_impl.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/repository/preferences_repository.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/preferences/save_preferences_usecase.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreferencesRemoteDatasource>(
          () => PreferencesRemoteDatasourceImpl(),
    );

    Get.lazyPut<PreferencesRepository>(
          () => PreferencesRepositoryImpl(
        Get.find<PreferencesRemoteDatasource>(),
      ),
    );

    Get.lazyPut<SavePreferencesUseCase>(
          () => SavePreferencesUseCase(
        Get.find<PreferencesRepository>(),
      ),
    );

    Get.lazyPut<OnBoardingController>(
          () => OnBoardingController(
        Get.find<SavePreferencesUseCase>(),
      ),
    );
  }
}