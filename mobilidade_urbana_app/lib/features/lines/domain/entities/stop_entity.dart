import 'package:equatable/equatable.dart';

class StopEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double? latitude;
  final double? longitude;
  final int? sequence;
  final String? arrivalTime;

  const StopEntity({
    required this.id,
    required this.name,
    this.description,
    this.latitude,
    this.longitude,
    this.sequence,
    this.arrivalTime,
  });

  @override
  List<Object?> get props => [id, name, description, latitude, longitude, sequence, arrivalTime];
}
