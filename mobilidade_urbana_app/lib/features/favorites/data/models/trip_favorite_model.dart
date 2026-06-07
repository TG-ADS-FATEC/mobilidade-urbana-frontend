import 'package:mobilidade_urbana_app/features/favorites/domain/entities/trip_favorite_entity.dart';

class TripFavoriteModel extends TripFavoriteEntity {
  const TripFavoriteModel({
    super.id,
    required super.name,
    required super.destinationLatitude,
    required super.destinationLongitude,
    super.createdAt,
    super.address,
  });

  factory TripFavoriteModel.fromEntity(TripFavoriteEntity e) => TripFavoriteModel(
        id: e.id,
        name: e.name,
        destinationLatitude: e.destinationLatitude,
        destinationLongitude: e.destinationLongitude,
        createdAt: e.createdAt,
        address: e.address,
      );

  factory TripFavoriteModel.fromJson(Map<String, dynamic> json) => TripFavoriteModel(
        id: json['favoriteTripId']?.toString(),
        name: json['favoriteTripName'] as String? ?? '',
        destinationLatitude: (json['destinationLatitude'] as num).toDouble(),
        destinationLongitude: (json['destinationLongitude'] as num).toDouble(),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'favoriteTripName': name,
        'destinationLatitude': destinationLatitude,
        'destinationLongitude': destinationLongitude,
      };
}
