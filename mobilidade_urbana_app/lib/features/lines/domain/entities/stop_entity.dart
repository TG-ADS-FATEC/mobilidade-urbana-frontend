import 'package:equatable/equatable.dart';

class StopEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double? latitude;
  final double? longitude;

  const StopEntity({
    required this.id,
    required this.name,
    this.description,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [id, name, description, latitude, longitude];
}
