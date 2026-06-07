import 'package:mobilidade_urbana_app/features/lines/data/models/line_model.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';

abstract class LineLocalDatasource {
  Future<List<LineModel>> getLines();
  Future<List<LineModel>> getMetroLines();
  Future<List<LineModel>> getTrainLines();
}

class LineLocalDatasourceImpl implements LineLocalDatasource {
  @override
  Future<List<LineModel>> getLines() async => [..._metroLines, ..._trainLines];

  @override
  Future<List<LineModel>> getMetroLines() async => _metroLines;

  @override
  Future<List<LineModel>> getTrainLines() async => _trainLines;
}

// ── Metrô ─────────────────────────────────────────────────────────────────────

const _metroLines = [
  LineModel(
    id: 'metro-1',
    code: '1',
    name: 'Linha 1 - Azul',
    type: LineType.metro,
    colorValue: 0xFF0455A1,
    agencyId: 'METRO',
  ),
  LineModel(
    id: 'metro-2',
    code: '2',
    name: 'Linha 2 - Verde',
    type: LineType.metro,
    colorValue: 0xFF007E5E,
    agencyId: 'METRO',
  ),
  LineModel(
    id: 'metro-3',
    code: '3',
    name: 'Linha 3 - Vermelha',
    type: LineType.metro,
    colorValue: 0xFFEE372F,
    agencyId: 'METRO',
  ),
  LineModel(
    id: 'metro-4',
    code: '4',
    name: 'Linha 4 - Amarela',
    type: LineType.metro,
    colorValue: 0xFFFFD400,
    textColorValue: 0xFF000000,
    agencyId: 'VIAQUATRO',
  ),
  LineModel(
    id: 'metro-5',
    code: '5',
    name: 'Linha 5 - Lilás',
    type: LineType.metro,
    colorValue: 0xFF9B2990,
    agencyId: 'VIAMOBILIDADE',
  ),
  LineModel(
    id: 'metro-15',
    code: '15',
    name: 'Linha 15 - Prata',
    type: LineType.metro,
    colorValue: 0xFF9E9E9E,
    agencyId: 'METRO',
  ),
  LineModel(
    id: 'metro-17',
    code: '17',
    name: 'Linha 17 - Ouro',
    type: LineType.metro,
    colorValue: 0xFFCBA135,
    agencyId: 'METRO',
  ),
];

// ── Trem ──────────────────────────────────────────────────────────────────────

const _trainLines = [
  LineModel(
    id: 'trem-7',
    code: '7',
    name: 'Linha 7 - Rubi',
    type: LineType.train,
    colorValue: 0xFFCE1126,
    agencyId: 'TIC_TRENS',
  ),
  LineModel(
    id: 'trem-8',
    code: '8',
    name: 'Linha 8 - Diamante',
    type: LineType.train,
    colorValue: 0xFF97999B,
    agencyId: 'VIAMOBILIDADE',
  ),
  LineModel(
    id: 'trem-9',
    code: '9',
    name: 'Linha 9 - Esmeralda',
    type: LineType.train,
    colorValue: 0xFF01A368,
    agencyId: 'VIAMOBILIDADE',
  ),
  LineModel(
    id: 'trem-10',
    code: '10',
    name: 'Linha 10 - Turquesa',
    type: LineType.train,
    colorValue: 0xFF00B0C7,
    agencyId: 'CPTM',
  ),
  LineModel(
    id: 'trem-11',
    code: '11',
    name: 'Linha 11 - Coral',
    type: LineType.train,
    colorValue: 0xFFF7941D,
    agencyId: 'CPTM',
  ),
  LineModel(
    id: 'trem-12',
    code: '12',
    name: 'Linha 12 - Safira',
    type: LineType.train,
    colorValue: 0xFF113D8B,
    agencyId: 'CPTM',
  ),
  LineModel(
    id: 'trem-13',
    code: '13',
    name: 'Linha 13 - Jade',
    type: LineType.train,
    colorValue: 0xFF00B398,
    agencyId: 'CPTM',
  ),
];
