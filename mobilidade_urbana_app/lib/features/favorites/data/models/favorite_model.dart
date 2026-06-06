import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';

class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    super.favoriteId,
    required super.favoriteName,
    super.shortName,
    super.routeType,
    super.routeId,
    super.createdAt,
    super.address,
  });

  factory FavoriteModel.fromEntity(FavoriteEntity entity) {
    return FavoriteModel(
      favoriteId: entity.favoriteId,
      favoriteName: entity.favoriteName,
      shortName: entity.shortName,
      routeType: entity.routeType,
      routeId: entity.routeId,
      address: entity.address,
      createdAt: entity.createdAt,
    );
  }

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      favoriteId: json['favoriteRouteId']?.toString(),
      favoriteName: json['favoriteRouteLongName'] as String? ?? '',
      shortName: json['favoriteRouteShortName'] as String?,
      routeType: json['routeType'] as String?,
      routeId: json['routeId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  /// Envia apenas o [routeId] ao adicionar um favorito no backend.
  Map<String, dynamic> toJson() => {
        'routeId': routeId,
      };
}