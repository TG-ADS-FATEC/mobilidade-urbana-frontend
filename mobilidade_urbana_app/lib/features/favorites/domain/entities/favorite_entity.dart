import 'package:equatable/equatable.dart';

class FavoriteEntity extends Equatable {
  /// ID do registro de favorito no backend (favoriteRouteId).
  final String? favoriteId;

  /// Nome longo da rota (favoriteRouteLongName).
  final String favoriteName;

  /// Código curto da rota, ex: "1012-10" (favoriteRouteShortName).
  final String? shortName;

  /// Tipo de transporte retornado pelo backend: "BUS", "METRO", "TRAIN".
  final String? routeType;

  /// ID da rota no GTFS (routeId) — enviado ao adicionar favorito.
  final String? routeId;

  final DateTime? createdAt;

  /// Endereço armazenado localmente (não vem do backend).
  final String? address;

  const FavoriteEntity({
    required this.favoriteName,
    this.favoriteId,
    this.shortName,
    this.routeType,
    this.routeId,
    this.createdAt,
    this.address,
  });

  @override
  List<Object?> get props => [
        favoriteId,
        favoriteName,
        shortName,
        routeType,
        routeId,
        createdAt,
        address,
      ];
}