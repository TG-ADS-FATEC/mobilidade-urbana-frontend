import 'package:equatable/equatable.dart';

class TripFavoriteEntity extends Equatable {
  final String? id;
  final String name;
  final double destinationLatitude;
  final double destinationLongitude;
  final DateTime? createdAt;

  /// Endereço legível — armazenado localmente (não vem do backend).
  final String? address;

  const TripFavoriteEntity({
    this.id,
    required this.name,
    required this.destinationLatitude,
    required this.destinationLongitude,
    this.createdAt,
    this.address,
  });

  @override
  List<Object?> get props =>
      [id, name, destinationLatitude, destinationLongitude, createdAt, address];
}
