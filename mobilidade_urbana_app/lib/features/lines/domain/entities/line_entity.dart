import 'package:equatable/equatable.dart';

enum LineType { bus, metro, train }

class LineEntity extends Equatable {
  /// routeId do GTFS — chave da linha no backend.
  final String? id;

  /// routeShortName — código curto, ex: "1012-10".
  final String code;

  /// routeLongName — nome completo, ex: "Term. Jd. Britania - Jd. Monte Belo".
  final String name;

  final LineType type;

  /// Cor de fundo da linha em ARGB int — ex: 0xFF509E2F.
  final int colorValue;

  /// Cor do texto sobre a cor da linha em ARGB int — ex: 0xFFFFFFFF.
  final int textColorValue;

  /// ID da agência operadora.
  final String? agencyId;

  final bool isFavorite;

  /// Paradas locais (metrô/trem). Nulo para ônibus — carregado via API.
  final List<String>? stops;

  const LineEntity({
    this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.colorValue,
    this.textColorValue = 0xFFFFFFFF,
    this.agencyId,
    this.isFavorite = false,
    this.stops,
  });

  @override
  List<Object?> get props =>
      [id, code, name, type, colorValue, textColorValue, agencyId, isFavorite, stops];
}
