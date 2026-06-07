import 'package:flutter/foundation.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';

class LineModel extends LineEntity {
  const LineModel({
    super.id,
    required super.code,
    required super.name,
    required super.type,
    required super.colorValue,
    super.textColorValue,
    super.agencyId,
    super.isFavorite,
    super.stops,
  });

  factory LineModel.fromEntity(LineEntity entity) => LineModel(
        id: entity.id,
        code: entity.code,
        name: entity.name,
        type: entity.type,
        colorValue: entity.colorValue,
        textColorValue: entity.textColorValue,
        agencyId: entity.agencyId,
        isFavorite: entity.isFavorite,
        stops: entity.stops,
      );

  /// Parseia a resposta do backend (RouteDTO).
  factory LineModel.fromJson(Map<String, dynamic> json) {
    debugPrint('[LineModel] parsing: ${json['routeId']} | color=${json['routeColor']} | textColor=${json['routeTextColor']} | type=${json['routeType']}');
    try {
      return LineModel(
        id: json['routeId'] as String?,
        code: json['routeShortName'] as String? ?? '',
        name: json['routeLongName'] as String? ?? '',
        type: _parseType(json['routeType']),
        colorValue: _parseColor(json['routeColor'] as String? ?? 'FF6B00'),
        textColorValue: _parseColor(json['routeTextColor'] as String? ?? 'FFFFFF'),
        agencyId: json['agencyId'] as String?,
      );
    } catch (e) {
      debugPrint('[LineModel] FAILED on: $json');
      debugPrint('[LineModel] error: $e');
      rethrow;
    }
  }

  /// Aceita nome do enum ("BUS", "METRO", "TRAIN")
  /// ou código GTFS numérico (1=Metro, 2=Trem, 3=Ônibus).
  static LineType _parseType(dynamic raw) {
    final value = raw?.toString().toUpperCase() ?? '';
    switch (value) {
      case 'METRO':
      case '1':
        return LineType.metro;
      case 'TRAIN':
      case '2':
        return LineType.train;
      default: // BUS, 3, ou qualquer outro
        return LineType.bus;
    }
  }

  /// Aceita hex sem #, ex: "509E2F" ou "FFFFFF".
  /// Adiciona alpha FF se tiver 6 dígitos.
  static int _parseColor(String hex) {
    final clean = hex.replaceAll('#', '').toUpperCase();
    final padded = clean.length == 6 ? 'FF$clean' : clean;
    return int.parse(padded, radix: 16);
  }
}
