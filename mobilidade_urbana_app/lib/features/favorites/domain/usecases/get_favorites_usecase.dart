

import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/repository/favorite_repository.dart';

class GetFavoritesUsecase {
  final FavoriteRepository repository;

  const GetFavoritesUsecase(this.repository);

  Future<DataState<List<FavoriteEntity>>> call() async {
    return await repository.getFavorites();
  }
}