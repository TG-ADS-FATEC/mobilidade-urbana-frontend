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
    stops: [
      'Jabaquara', 'Conceição', 'São Judas', 'Saúde', 'Praça da Árvore',
      'Santa Cruz', 'Vila Mariana', 'Ana Rosa', 'Paraíso', 'Vergueiro',
      'São Joaquim', 'Liberdade', 'Sé', 'São Bento', 'Luz', 'Tiradentes',
      'Armênia', 'Portuguesa-Tietê', 'Carandiru', 'Santana',
      'Jardim São Paulo-Ayrton Senna', 'Parada Inglesa', 'Tucuruvi',
    ],
  ),
  LineModel(
    id: 'metro-2',
    code: '2',
    name: 'Linha 2 - Verde',
    type: LineType.metro,
    colorValue: 0xFF007E5E,
    agencyId: 'METRO',
    stops: [
      'Vila Madalena', 'Sumaré', 'Clínicas', 'Consolação', 'Trianon-Masp',
      'Brigadeiro', 'Paraíso', 'Ana Rosa', 'Chácara Klabin',
      'Alto do Ipiranga', 'Santos-Imigrantes', 'Sacomã',
      'Tamanduateí', 'Vila Prudente',
    ],
  ),
  LineModel(
    id: 'metro-3',
    code: '3',
    name: 'Linha 3 - Vermelha',
    type: LineType.metro,
    colorValue: 0xFFEE372F,
    agencyId: 'METRO',
    stops: [
      'Palmeiras-Barra Funda', 'Marechal Deodoro', 'Santa Cecília',
      'República', 'Higienópolis-Mackenzie', 'Anhangabaú', 'Sé',
      'Pedro II', 'Brás', 'Bresser-Mooca', 'Belém', 'Tatuapé',
      'Carrão', 'Penha', 'Vila Matilde', 'Guilhermina-Esperança',
      'Patriarca', 'Artur Alvim', 'Corinthians-Itaquera',
    ],
  ),
  LineModel(
    id: 'metro-4',
    code: '4',
    name: 'Linha 4 - Amarela',
    type: LineType.metro,
    colorValue: 0xFFFFD400,
    textColorValue: 0xFF000000,
    agencyId: 'VIAQUATRO',
    stops: [
      'Luz', 'República', 'Paulista', 'Fradique Coutinho', 'Faria Lima',
      'Butantã', 'Pinheiros', 'São Paulo-Morumbi', 'Higienópolis-Mackenzie',
      'Oscar Freire', 'Consolação', 'Vila Sônia',
    ],
  ),
  LineModel(
    id: 'metro-5',
    code: '5',
    name: 'Linha 5 - Lilás',
    type: LineType.metro,
    colorValue: 0xFF9B2990,
    agencyId: 'VIAMOBILIDADE',
    stops: [
      'Capão Redondo', 'Campo Limpo', 'Vila das Belezas', 'Giovanni Gronchi',
      'Socorro', 'Borba Gato', 'Adolfo Pinheiro', 'Alto da Boa Vista',
      'Brooklin', 'Campo Belo', 'Eucaliptos', 'Moema', 'AACD-Servidor',
      'Hospital São Paulo', 'Santa Cruz', 'Chácara Klabin', 'Largo Treze',
      'Autódromo', 'Jururatuba', 'Primavera-Interlagos', 'Grajaú',
    ],
  ),
  LineModel(
    id: 'metro-15',
    code: '15',
    name: 'Linha 15 - Prata',
    type: LineType.metro,
    colorValue: 0xFF9E9E9E,
    agencyId: 'METRO',
    stops: [
      'Vila Prudente', 'Oratório', 'São Lucas', 'Camilo Haddad',
      'Vila Tolstói', 'Vila União', 'Jardim Planalto', 'Sapopemba',
      'Fazenda da Juta', 'São Mateus', 'Jd. Colonial',
    ],
  ),
  LineModel(
    id: 'metro-17',
    code: '17',
    name: 'Linha 17 - Ouro',
    type: LineType.metro,
    colorValue: 0xFFCBA135,
    agencyId: 'METRO',
    stops: [
      'Congonhas', 'Câmara Municipal', 'Morumbi', 'Henrique Schaumann',
      'Jorge João Saad', 'Pacaembu', 'Cidade Jardim', 'Hospital das Clínicas',
    ],
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
    stops: [
      'Luz', 'Palmeiras-Barra Funda', 'Lapa', 'Piqueri', 'Pirituba',
      'Jaraguá', 'Vila Aurora', 'Perus', 'Caieiras', 'Franco da Rocha',
      'Baltazar Fidélis', 'Francisco Morato', 'Campo Limpo Paulista',
      'Várzea Paulista', 'Botujuru', 'Jundiaí',
    ],
  ),
  LineModel(
    id: 'trem-8',
    code: '8',
    name: 'Linha 8 - Diamante',
    type: LineType.train,
    colorValue: 0xFF97999B,
    agencyId: 'VIAMOBILIDADE',
    stops: [
      'Júlio Prestes', 'Palmeiras-Barra Funda', 'Lapa', 'Domingos de Moraes',
      'Imperatriz Leopoldina', 'Pres. Altino', 'Osasco',
      'Comandante Sampaio', 'Quitaúna', 'General Miguel Costa', 'Carapicuíba',
      'Santa Terezina', 'Antonio João', 'Barueri', 'Jd. Belval', 'Jd. Silveira',
      'Jandira', 'Sagrado Coração', 'Engº Cardoso', 'Itapevi',
      'Santa Rita', 'Ambuitá', 'Amador Bueno',
    ],
  ),
  LineModel(
    id: 'trem-9',
    code: '9',
    name: 'Linha 9 - Esmeralda',
    type: LineType.train,
    colorValue: 0xFF01A368,
    agencyId: 'VIAMOBILIDADE',
    stops: [
      'Osasco', 'Presidente Altino', 'Ceasa', 'Vila Lobos-Jaguaré',
      'Cidade Universitária', 'Pinheiros', 'Vila Olímpia', 'Berrini',
      'Morumbi', 'Granja Julieta', 'João Dias', 'Santo Amaro',
      'Primavera-Interlagos', 'Autódromo', 'Jurubatuba',
      'Bruno Daniel', 'Santo André',
    ],
  ),
  LineModel(
    id: 'trem-10',
    code: '10',
    name: 'Linha 10 - Turquesa',
    type: LineType.train,
    colorValue: 0xFF00B0C7,
    agencyId: 'CPTM',
    stops: [
      'Brás', 'Tatuapé', 'Juventus-Mooca', 'Ipiranga', 'Tamanduateí',
      'São Caetano do Sul', 'Utinga', 'Santo André', 'Prefeito Saladino',
      'Capuava', 'Mauá', 'Guapituba', 'Ribeirão Pires',
      'Rio Grande da Serra',
    ],
  ),
  LineModel(
    id: 'trem-11',
    code: '11',
    name: 'Linha 11 - Coral',
    type: LineType.train,
    colorValue: 0xFFF7941D,
    agencyId: 'CPTM',
    stops: [
      'Luz', 'Brás', 'Tatuapé', 'Engenheiro Goulart', 'Dom Bosco',
      'José Bonifácio', 'Ferreira', 'Comendador Ermelino',
      'São Miguel Paulista', 'Jardim Helena-Vila Mara', 'Itaim Paulista',
      'Jardim Romano', 'Engenheiro Manoel Feio', 'Braz Cubas', 'Poá',
      'Calmon Viana', 'Suzano', 'Estudantes', 'Hamamoto',
      'Mogi das Cruzes',
    ],
  ),
  LineModel(
    id: 'trem-12',
    code: '12',
    name: 'Linha 12 - Safira',
    type: LineType.train,
    colorValue: 0xFF113D8B,
    agencyId: 'CPTM',
    stops: [
      'Brás', 'Tatuapé', 'Engenheiro Goulart', 'USP Leste',
      'Comendador Ermelino', 'São Miguel Paulista', 'Jardim Helena-Vila Mara',
      'Itaim Paulista', 'Jardim Romano', 'Engenheiro Manoel Feio',
      'Varginha', 'Calmon Viana', 'Suzano', 'Guararema',
    ],
  ),
  LineModel(
    id: 'trem-13',
    code: '13',
    name: 'Linha 13 - Jade',
    type: LineType.train,
    colorValue: 0xFF00B398,
    agencyId: 'CPTM',
    stops: [
      'Engonhas', 'Guarulhos-Cecap', 'Parada Rodoviária',
      'Aeroporto-Guarulhos',
    ],
  ),
];
