import 'package:get_it/get_it.dart';
import 'package:mobilidade_urbana_app/features/profile/data/data_sources/preferences_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/profile/data/data_sources/profile_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/profile/data/repository/preferences_repository_impl.dart';
import 'package:mobilidade_urbana_app/features/profile/data/repository/profile_repository_impl.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/repository/preferences_repository.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/repository/profile_repository.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/preferences/get_preferences_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/preferences/save_preferences_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/preferences/update_preferences_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/profile/delete_profile_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/profile/get_profile_usecase.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/profile/update_profile_usecase.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ---- Profile ----
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteProfileUseCase>(
    () => DeleteProfileUseCase(sl()),
  );

  // ---- Preferences ----
  sl.registerLazySingleton<PreferencesRemoteDatasource>(
    () => PreferencesRemoteDatasourceImpl(),
  );
  sl.registerLazySingleton<PreferencesRepository>(
    () => PreferencesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetPreferencesUsecase>(
    () => GetPreferencesUsecase(sl()),
  );
  sl.registerLazySingleton<UpdatePreferencesUsecase>(
    () => UpdatePreferencesUsecase(sl()),
  );
  sl.registerLazySingleton<SavePreferencesUseCase>(
    () => SavePreferencesUseCase(sl()),
  );
}
