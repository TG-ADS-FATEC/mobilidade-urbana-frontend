
import 'package:mobilidade_urbana_app/features/profile/domain/entities/profile.entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.deviceToken,
    super.name,
    super.avatarPath,
    required super.createdAt,
    required super.updatedAt,
    required super.preferenceId,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      deviceToken: json['deviceToken']?.toString() ?? '',
      name: json['name'] as String?,
      avatarPath: json['avatarPath'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      preferenceId: json['preferenceId']?.toString() ?? '',
    );
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      deviceToken: entity.deviceToken,
      name: entity.name,
      avatarPath: entity.avatarPath,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      preferenceId: entity.preferenceId,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'avatarPath': avatarPath,
  };
}