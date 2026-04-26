

import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/features/profile/data/data_sources/preferences_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/profile/data/repository/preferences_repository_impl.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/repository/preferences_repository.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/preferences/get_preferences_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/preferences/update_preferences_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/controllers/preferences_controller.dart';

class OnboadingBinding extends Bindings{
  @override
  void dependencies() {

    // 1. DataSource
    Get.lazyPut<PreferencesRemoteDatasource>(
          () => PreferencesRemoteDatasourceImpl(),
    );

    // 2. Repository
    Get.lazyPut<PreferencesRepository>(
          () => PreferencesRepositoryImpl(
        Get.find<PreferencesRemoteDatasource>(),
      ),
    );

    // 3. UseCases
    Get.lazyPut<GetPreferencesUsecase>(
          () => GetPreferencesUsecase(
        Get.find<PreferencesRepository>(),
      ),
    );
    Get.lazyPut<UpdatePreferencesUsecase>(
          () => UpdatePreferencesUsecase(
        Get.find<PreferencesRepository>(),
      ),
    );

    // 4. Controller
    Get.lazyPut<PreferencesController>(
          () => PreferencesController(
        Get.find<GetPreferencesUsecase>(),
        Get.find<UpdatePreferencesUsecase>(),
      ),
    );
  }
}

