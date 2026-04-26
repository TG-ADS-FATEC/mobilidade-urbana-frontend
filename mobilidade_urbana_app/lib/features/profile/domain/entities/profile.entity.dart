import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String deviceToken;
  final String? name;
  final String? avatarPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String preferenceId;

  const ProfileEntity({
    required this.id,
    required this.deviceToken,
    this.name,
    this.avatarPath,
    required this.createdAt,
    required this.updatedAt,
    required this.preferenceId,
  });

  ProfileEntity copyWith({
    String? id,
    String? deviceToken,
    String? name,
    String? avatarPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? preferenceId,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      deviceToken: deviceToken ?? this.deviceToken,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      preferenceId: preferenceId ?? this.preferenceId,
    );
  }

  @override
  List<Object?> get props => [id, deviceToken, name, avatarPath, createdAt, updatedAt, preferenceId];


}