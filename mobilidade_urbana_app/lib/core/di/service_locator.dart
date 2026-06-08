import 'package:get_it/get_it.dart';
import 'package:mobilidade_urbana_app/features/favorites/data/data_sources/favorite_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/lines/data/data_sources/line_local_datasource.dart';
import 'package:mobilidade_urbana_app/features/lines/data/data_sources/line_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/lines/data/data_sources/stop_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/lines/data/repository/line_repository_impl.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/repository/line_repository.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/usecases/get_lines_usecase.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/usecases/get_metro_lines_usecase.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/usecases/get_train_lines_usecase.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/usecases/search_lines_usecase.dart';
import 'package:mobilidade_urbana_app/features/favorites/data/data_sources/trip_favorite_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/favorites/data/repository/favorite_repository_impl.dart';
import 'package:mobilidade_urbana_app/features/favorites/data/repository/trip_favorite_repository_impl.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/repository/favorite_repository.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/repository/trip_favorite_repository.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/usecases/add_favorites_usecase.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/usecases/delete_favorite_usecase.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/usecases/update_favorite_usecase.dart';
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
import 'package:mobilidade_urbana_app/features/profile/domain/usecases/profile/save_profile_usecase.dart';
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
  sl.registerLazySingleton<SaveProfileUseCase>(
    () => SaveProfileUseCase(sl()),
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

  // ---- Linhas ----
  sl.registerLazySingleton<LineRemoteDatasource>(
    () => LineRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<StopRemoteDatasource>(
    () => StopRemoteDatasourceImpl(),
  );
  // LineLocalDatasource mantido para testes manuais
  sl.registerLazySingleton<LineLocalDatasource>(
    () => LineLocalDatasourceImpl(),
  );
  sl.registerLazySingleton<LineRepository>(
    () => LineRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<GetLinesUsecase>(
    () => GetLinesUsecase(sl()),
  );
  sl.registerLazySingleton<GetMetroLinesUsecase>(
    () => GetMetroLinesUsecase(sl()),
  );
  sl.registerLazySingleton<GetTrainLinesUsecase>(
    () => GetTrainLinesUsecase(sl()),
  );
  sl.registerLazySingleton<SearchLinesUsecase>(
    () => SearchLinesUsecase(sl()),
  );

  // ---- Favoritos (rotas) ----
  sl.registerLazySingleton<FavoriteRemoteDatasource>(
      () => FavoriteRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<FavoriteRepository>(
        () => FavoriteRepositoryImpl(sl()),
  );

  // ---- Favoritos (trips) ----
  sl.registerLazySingleton<TripFavoriteRemoteDatasource>(
      () => TripFavoriteRemoteDatasourceImpl(),
  );
  sl.registerLazySingleton<TripFavoriteRepository>(
      () => TripFavoriteRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetFavoritesUsecase>(
        () => GetFavoritesUsecase(sl()),
  );
  sl.registerLazySingleton<AddFavoritesUsecase>(
        () => AddFavoritesUsecase(sl()),
  );
  sl.registerLazySingleton<UpdateFavoriteUsecase>(
        () => UpdateFavoriteUsecase(sl()),
  );
  sl.registerLazySingleton<DeleteFavoriteUsecase>(
        () => DeleteFavoriteUsecase(sl()),
  );

}
