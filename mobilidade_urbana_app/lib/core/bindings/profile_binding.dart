
import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/features/profile/data/data_sources/profile_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/profile/data/repository/profile_repository_impl.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/repository/profile_repository.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/profile/delete_profile_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/profile/get_profile_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/profile/update_profile_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/controllers/profile_controller.dart';


class ProfileBinding extends Bindings{
  @override
  void dependencies() {
    // ---- Profile ----
    // 1. DataSource
    Get.lazyPut<ProfileRemoteDataSource>(
          () => ProfileRemoteDataSourceImpl(),
    );

    // 2. Repository
    Get.lazyPut<ProfileRepository>(
          () => ProfileRepositoryImpl(
        Get.find<ProfileRemoteDataSource>(),
      ),
    );

    // 3. UseCases
    Get.lazyPut<GetProfileUseCase>(
          () => GetProfileUseCase(
        Get.find<ProfileRepository>(),
      ),
    );
    Get.lazyPut<UpdateProfileUseCase>(
          () => UpdateProfileUseCase(
        Get.find<ProfileRepository>(),
      ),
    );
    Get.lazyPut<DeleteProfileUseCase>(
          () => DeleteProfileUseCase(
        Get.find<ProfileRepository>(),
      ),
    );
    // 4. Controller
    Get.lazyPut<ProfileController>(
          () => ProfileController(
        Get.find<GetProfileUseCase>(),
        Get.find<UpdateProfileUseCase>(),
        Get.find<DeleteProfileUseCase>(),
      ),
    );
  }
}