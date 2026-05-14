import 'package:equatable/equatable.dart';

enum TransportType {
  bus('BUS'),
  subway('SUBWAY'),
  train('TRAIN');

  final String value;
  const TransportType(this.value);

  static TransportType fromJson(String value) {
    return TransportType.values.firstWhere(
          (e) => e.value == value.toUpperCase(),
      orElse: () => throw Exception('TransportType inválido: $value'),
    );
  }
}

enum RoutePreference {
  fastest('FASTEST'),
  fewerTransfers('FEWER_TRANSFERS'),
  leastWalking('LESS_WALKING');

  final String value;
  const RoutePreference(this.value);
  static RoutePreference fromJson(String value) {
    return RoutePreference.values.firstWhere(
          (e) => e.value == value.toUpperCase(),
      orElse: () => throw Exception('RoutePreference inválido: $value'),
    );
  }
}

class PreferencesEntity extends Equatable {
  final List<TransportType> transportTypes;
  final RoutePreference routePreference;
  final bool slowPace;
  final int maxWalkingTime;
  final DateTime updatedAt;
  final String deviceToken;

  const PreferencesEntity({
    required this.transportTypes,
    required this.routePreference,
    required this.slowPace,
    required this.maxWalkingTime,
    required this.updatedAt,
    required this.deviceToken, Object? preferenceId,
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
    transportTypes,
    routePreference,
    slowPace,
    maxWalkingTime,
    updatedAt,
    deviceToken,
  ];
}