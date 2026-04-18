// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OnboardingModelAdapter extends TypeAdapter<OnboardingModel> {
  @override
  final int typeId = 0;

  @override
  OnboardingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OnboardingModel(
      deviceToken: fields[0] as String,
      transportPreferences: (fields[1] as List).cast<String>(),
      selectedRoutePreference: fields[2] as String,
      slowWalkingPace: fields[3] as bool,
      walkingDuration: fields[4] as double,
      isSynced: fields[5] as bool,
      isCompleted: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OnboardingModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.deviceToken)
      ..writeByte(1)
      ..write(obj.transportPreferences)
      ..writeByte(2)
      ..write(obj.selectedRoutePreference)
      ..writeByte(3)
      ..write(obj.slowWalkingPace)
      ..writeByte(4)
      ..write(obj.walkingDuration)
      ..writeByte(5)
      ..write(obj.isSynced)
      ..writeByte(6)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
