import 'package:equatable/equatable.dart';

enum TransportType { bus, subway, walking, cycling, car }
enum RoutePreference { fastest, shortest, leastWalking }

class PreferencesEntity extends Equatable {
  final int preferenceId;
  final List<TransportType> transportTypes;
  final RoutePreference routePreference;
  final bool slowPace;
  final int maxWalkingTime;
  final DateTime updatedAt;
  final String deviceToken;

  const PreferencesEntity({
    required this.preferenceId,
    required this.transportTypes,
    required this.routePreference,
    required this.slowPace,
    required this.maxWalkingTime,
    required this.updatedAt,
    required this.deviceToken,
  });

  PreferencesEntity copyWith({
    int? preferenceId,
    List<TransportType>? transportTypes,
    RoutePreference? routePreference,
    bool? slowPace,
    int? maxWalkingTime,
    DateTime? updatedAt,
    String? deviceToken,
  }) {
    return PreferencesEntity(
      preferenceId: preferenceId ?? this.preferenceId,
      transportTypes: transportTypes ?? this.transportTypes,
      routePreference: routePreference ?? this.routePreference,
      slowPace: slowPace ?? this.slowPace,
      maxWalkingTime: maxWalkingTime ?? this.maxWalkingTime,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceToken: deviceToken ?? this.deviceToken
    );
  }

  @override
  List<Object?> get props => [
    preferenceId,
    transportTypes,
    routePreference,
    slowPace,
    maxWalkingTime,
    updatedAt,
    deviceToken,
  ];
}