import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/repository/favorite_repository.dart';

class DeleteFavoriteUsecase {
  final FavoriteRepository repository;
  const DeleteFavoriteUsecase(this.repository);

  Future<DataState<void>> call(String id) async {
    return await repository.deleteFavorite(id);
  }
}