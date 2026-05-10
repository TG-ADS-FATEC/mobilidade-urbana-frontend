import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences_entity.dart';

class PreferencesModel extends PreferencesEntity{
  const PreferencesModel({
    super.preferenceId,
    required super.transportTypes,
    required super.routePreference,
    required super.slowPace,
    required super.maxWalkingTime,
    required super.updatedAt,
    required super.deviceToken,
  });

  factory PreferencesModel.fromEntity(PreferencesEntity entity) {
    return PreferencesModel(
      transportTypes: entity.transportTypes,
      routePreference: entity.routePreference,
      slowPace: entity.slowPace,
      maxWalkingTime: entity.maxWalkingTime,
      updatedAt: entity.updatedAt,
      deviceToken: entity.deviceToken,
    );
  }

  factory PreferencesModel.fromJson(Map<String, dynamic> json) {
    return PreferencesModel(
      preferenceId: json['preferenceId']?.toString(),
      transportTypes: (json['transportTypes'] as List)
          .map((e) => TransportType.fromJson(e as String))
          .toList(),
      routePreference: RoutePreference.fromJson(json['routePreference'] as String),
      slowPace: json['slowPace'] as bool? ?? false,
      maxWalkingTime: json['maxWalkingTime'] as int? ?? 0,
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      deviceToken: '${json['deviceToken']}',
    );
  }

  Map<String, dynamic> toJson() => {
    'transportTypes': transportTypes.map((e) => e.value).toList(),
    'routePreference': routePreference.value,
    'slowPace': slowPace,
    'maxWalkingTime': maxWalkingTime,
    'updatedAt': updatedAt.toIso8601String(),
    'deviceToken': deviceToken,
  };



}