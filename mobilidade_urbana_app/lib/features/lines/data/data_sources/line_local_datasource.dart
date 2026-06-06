import 'package:mobilidade_urbana_app/features/lines/data/models/line_model.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';

abstract class LineLocalDatasource {
  Future<List<LineModel>> getLines();
}

class LineLocalDatasourceImpl implements LineLocalDatasource {
  @override
  Future<List<LineModel>> getLines() async => _mockLines;
}

// ── Mock ──────────────────────────────────────────────────────────────────────

const _mockLines = [
  LineModel(code: '809H-10', name: 'Jardim Boa Vista - Lapa',       type: LineType.bus,   colorValue: 0xFFFF6B00, isFavorite: true),
  LineModel(code: '748A-41', name: 'Jardim Peri Peri - Lapa',       type: LineType.bus,   colorValue: 0xFFFF6B00, isFavorite: true),
  LineModel(code: '107A-10', name: 'Lapa - Metro Santana',          type: LineType.bus,   colorValue: 0xFFFF6B00),
  LineModel(code: '251P-10', name: 'Pinheiros - Metro Ana Rosa',    type: LineType.bus,   colorValue: 0xFFFF6B00),
  LineModel(code: '675A-10', name: 'Itaim Paulista - Se',           type: LineType.bus,   colorValue: 0xFFFF6B00),
  LineModel(code: '1',       name: 'Linha Azul - Jabaquara',        type: LineType.metro, colorValue: 0xFF0057A8, isFavorite: true),
  LineModel(code: '2',       name: 'Linha Verde - Vila Madalena',   type: LineType.metro, colorValue: 0xFF007A47),
  LineModel(code: '3',       name: 'Linha Vermelha - Palmeiras',    type: LineType.metro, colorValue: 0xFFE30613),
  LineModel(code: '4',       name: 'Linha Amarela - Butanta',       type: LineType.metro, colorValue: 0xFFFFCC00),
  LineModel(code: '5',       name: 'Linha Lilas - Capao Redondo',   type: LineType.metro, colorValue: 0xFF9B5EA2),
  LineModel(code: '7',       name: 'Linha Rubi - Jundiai',          type: LineType.train, colorValue: 0xFFBE1E2D),
  LineModel(code: '8',       name: 'Linha Diamante - Amador Bueno', type: LineType.train, colorValue: 0xFF9E9E9E),
  LineModel(code: '9',       name: 'Linha Esmeralda - Osasco',      type: LineType.train, colorValue: 0xFF00A651, isFavorite: true),
  LineModel(code: '10',      name: 'Linha Turquesa - Rio Grande',   type: LineType.train, colorValue: 0xFF009BA5),
  LineModel(code: '11',      name: 'Linha Coral - Estudantes',      type: LineType.train, colorValue: 0xFFE05206),
  LineModel(code: '12',      name: 'Linha Safira - Calmon Viana',   type: LineType.train, colorValue: 0xFF003893),
  LineModel(code: '13',      name: 'Linha Jade - Aeroporto',        type: LineType.train, colorValue: 0xFF00884A),
];
