import 'package:hive/hive.dart';

part 'onboarding_model.g.dart';

@HiveType(typeId: 0)
class OnboardingModel extends HiveObject {
  @HiveField(0)
  final String deviceToken;

  @HiveField(1)
  final List<String> transportPreferences;

  @HiveField(2)
  final String selectedRoutePreference;

  @HiveField(3)
  final bool slowWalkingPace;

  @HiveField(4)
  final double walkingDuration;

  @HiveField(5)
  bool isSynced;

  @HiveField(6)
  bool isCompleted;

  OnboardingModel({
    required this.deviceToken,
    required this.transportPreferences,
    required this.selectedRoutePreference,
    required this.slowWalkingPace,
    required this.walkingDuration,
    this.isSynced = false,
    this.isCompleted = false,
  });

  // só campos que a API precisa receber
  Map<String, dynamic> toJson() => {
    'deviceToken': deviceToken,
    'transportPreferences': transportPreferences,
    'selectedRoutePreference': selectedRoutePreference,
    'slowWalkingPace': slowWalkingPace,
    'walkingDuration': walkingDuration,
  };

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      deviceToken: json['deviceToken'] as String? ?? '',
      transportPreferences: List<String>.from(json['transportPreferences'] ?? []),
      selectedRoutePreference: json['selectedRoutePreference'] as String? ?? '',
      slowWalkingPace: json['slowWalkingPace'] as bool? ?? false,
      walkingDuration: (json['walkingDuration'] as num?)?.toDouble() ?? 0.0,
      isSynced: json['isSynced'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  // ② copyWith — só precisa passar o que quer mudar
  OnboardingModel copyWith({
    String? deviceToken,
    List<String>? transportPreferences,
    String? selectedRoutePreference,
    bool? slowWalkingPace,
    double? walkingDuration,
    bool? isSynced,
    bool? isCompleted,
  }) {
    return OnboardingModel(
      deviceToken: deviceToken ?? this.deviceToken,
      transportPreferences: transportPreferences ?? this.transportPreferences,
      selectedRoutePreference: selectedRoutePreference ?? this.selectedRoutePreference,
      slowWalkingPace: slowWalkingPace ?? this.slowWalkingPace,
      walkingDuration: walkingDuration ?? this.walkingDuration,
      isSynced: isSynced ?? this.isSynced,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}