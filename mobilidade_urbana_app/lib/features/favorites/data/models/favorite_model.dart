
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';

class FavoriteModel extends FavoriteEntity {

  const FavoriteModel({
    super.favoriteId,
    required super.favoriteName,
    super.address,
    super.createdAt,
  });

  factory FavoriteModel.fromEntity(FavoriteEntity entity) {
    return FavoriteModel(
      favoriteId: entity.favoriteId,
      favoriteName: entity.favoriteName,
      address: entity.address,
    );
  }

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      favoriteId: json['favoriteId']?.toString(),
      favoriteName: json['favoriteName'] as String,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'favoriteId': favoriteId,
    'favoriteName': favoriteName,
    'address': address,
  };



}