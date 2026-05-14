

import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<DataState<List<FavoriteEntity>>> getFavorites();
  Future<DataState<FavoriteEntity>> addFavorite(FavoriteEntity favorite);
  Future<DataState<FavoriteEntity>> updateFavorite(FavoriteEntity favorite);
  Future<DataState<void>> deleteFavorite(String id);
}