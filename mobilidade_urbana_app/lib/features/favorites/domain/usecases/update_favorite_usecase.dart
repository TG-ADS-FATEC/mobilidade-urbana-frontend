import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/repository/favorite_repository.dart';

class UpdateFavoriteUsecase {
  final FavoriteRepository repository;
  const UpdateFavoriteUsecase(this.repository);

  Future<DataState<FavoriteEntity>> call({required FavoriteEntity favorite}) async {
    return await repository.updateFavorite(
      favorite,
    );
  }
}