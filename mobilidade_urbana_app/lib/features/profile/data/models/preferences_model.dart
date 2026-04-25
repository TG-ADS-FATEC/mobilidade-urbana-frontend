

import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences.entity.dart';

class PreferencesModel extends PreferencesEntity{
  const PreferencesModel({
    required super.preferenceId,
    required super.transportTypes,
    required super.routePreference,
    required super.slowPace,
    required super.maxWalkingTime,
    required super.updatedAt,
  });

  factory PreferencesModel.fromEntity(PreferencesEntity entity) {
    return PreferencesModel(
      preferenceId: entity.preferenceId,
      transportTypes: entity.transportTypes,
      routePreference: entity.routePreference,
      slowPace: entity.slowPace,
      maxWalkingTime: entity.maxWalkingTime,
      updatedAt: entity.updatedAt,
    );
  }

  factory PreferencesModel.fromJson(Map<String, dynamic> json) {
    return PreferencesModel(
      preferenceId: json['preferenceId'],
      transportTypes: List<TransportType>.from(json['transportTypes'] ?? []),
      routePreference: json['routePreference'],
      slowPace: json['slowPace'] as bool? ?? false,
      maxWalkingTime: json['maxWalkingTime'] as int? ?? 0,
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'preferenceId': preferenceId,
    'transportTypes': transportTypes,
    'routePreference': routePreference,
    'slowPace': slowPace,
    'maxWalkingTime': maxWalkingTime,
    'updatedAt': updatedAt.toIso8601String(),
  };



}