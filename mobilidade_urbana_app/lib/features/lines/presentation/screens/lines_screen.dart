import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/features/lines/data/transit_line.dart';
import 'package:mobilidade_urbana_app/features/lines/presentation/widgets/line_widgets.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

// ── Dados mock ────────────────────────────────────────────────────────────────

const _mockLines = [
  TransitLine(code: '809H-10', name: 'Jardim Boa Vista - Lapa',       type: LineType.bus,   color: Color(0xFFFF6B00), isFavorite: true),
  TransitLine(code: '748A-41', name: 'Jardim Peri Peri - Lapa',       type: LineType.bus,   color: Color(0xFFFF6B00), isFavorite: true),
  TransitLine(code: '107A-10', name: 'Lapa - Metrô Santana',          type: LineType.bus,   color: Color(0xFFFF6B00)),
  TransitLine(code: '251P-10', name: 'Pinheiros - Metrô Ana Rosa',    type: LineType.bus,   color: Color(0xFFFF6B00)),
  TransitLine(code: '675A-10', name: 'Itaim Paulista - Sé',           type: LineType.bus,   color: Color(0xFFFF6B00)),
  TransitLine(code: '1',       name: 'Linha Azul - Jabaquara',        type: LineType.metro, color: Color(0xFF0057A8), isFavorite: true),
  TransitLine(code: '2',       name: 'Linha Verde - Vila Madalena',   type: LineType.metro, color: Color(0xFF007A47)),
  TransitLine(code: '3',       name: 'Linha Vermelha - Palmeiras',    type: LineType.metro, color: Color(0xFFE30613)),
  TransitLine(code: '4',       name: 'Linha Amarela - Butantã',       type: LineType.metro, color: Color(0xFFFFCC00)),
  TransitLine(code: '5',       name: 'Linha Lilás - Capão Redondo',   type: LineType.metro, color: Color(0xFF9B5EA2)),
  TransitLine(code: '7',       name: 'Linha Rubi - Jundiaí',          type: LineType.train, color: Color(0xFFBE1E2D)),
  TransitLine(code: '8',       name: 'Linha Diamante - Amador Bueno', type: LineType.train, color: Color(0xFF9E9E9E)),
  TransitLine(code: '9',       name: 'Linha Esmeralda - Osasco',      type: LineType.train, color: Color(0xFF00A651), isFavorite: true),
  TransitLine(code: '10',      name: 'Linha Turquesa - Rio Grande',   type: LineType.train, color: Color(0xFF009BA5)),
  TransitLine(code: '11',      name: 'Linha Coral - Estudantes',      type: LineType.train, color: Color(0xFFE05206)),
  TransitLine(code: '12',      name: 'Linha Safira - Calmon Viana',   type: LineType.train, color: Color(0xFF003893)),
  TransitLine(code: '13',      name: 'Linha Jade - Aeroporto',        type: LineType.train, color: Color(0xFF00884A)),
];

// ── Tela ──────────────────────────────────────────────────────────────────────

class LinesScreen extends StatefulWidget {
  const LinesScreen({super.key});

  @override
  State<LinesScreen> createState() => _LinesScreenState();
}

class _LinesScreenState extends State<LinesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _searchController = TextEditingController();
    _searchController.addListener(
      () => setState(() => _query = _searchController.text.toLowerCase()),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<TransitLine> _filtered(int tabIndex) {
    List<TransitLine> base;
    switch (tabIndex) {
      case 0:  base = _mockLines.where((l) => l.isFavorite).toList();
      case 2:  base = _mockLines.where((l) => l.type == LineType.bus).toList();
      case 3:  base = _mockLines.where((l) => l.type == LineType.train).toList();
      case 4:  base = _mockLines.where((l) => l.type == LineType.metro).toList();
      default: base = _mockLines;
    }
    if (_query.isEmpty) return base;
    return base.where((l) =>
        l.code.toLowerCase().contains(_query) ||
        l.name.toLowerCase().contains(_query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: TSizes.md,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: TColors.soothingLime,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.directions_bus, color: Colors.black, size: 18),
            ),
            const SizedBox(width: TSizes.xs),
            Text(
              'sptrans',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(104),
          child: Column(
            children: [
              // ── Search bar ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm,
                  vertical: TSizes.xs,
                ),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? TColors.darkSurface : TColors.lightGrey,
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                  child: Row(
                    children: [
                      Icon(Icons.search,
                          color: isDark
                              ? TColors.darkTextSecondary
                              : TColors.textSecondary,
                          size: TSizes.iconMd),
                      const SizedBox(width: TSizes.xs),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Pesquise uma linha',
                            border: InputBorder.none,
                            hintStyle:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: isDark
                                          ? TColors.darkTextSecondary
                                          : TColors.textSecondary,
                                    ),
                          ),
                        ),
                      ),
                      if (_query.isNotEmpty)
                        GestureDetector(
                          onTap: _searchController.clear,
                          child: const Icon(Icons.close,
                              size: TSizes.iconMd, color: TColors.grey),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Tabs ──────────────────────────────────────────────────
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: TColors.soothingLime,
                indicatorWeight: 3,
                labelColor: TColors.soothingLime,
                unselectedLabelColor: isDark
                    ? TColors.darkTextSecondary
                    : TColors.textSecondary,
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14),
                unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w400, fontSize: 14),
                tabs: const [
                  Tab(text: 'Favoritos'),
                  Tab(text: 'Todos'),
                  Tab(text: 'Ônibus'),
                  Tab(text: 'Trem'),
                  Tab(text: 'Metrô'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(5, (i) {
          final lines = _filtered(i);
          if (lines.isEmpty) {
            return Center(
              child: Text(
                'Nenhuma linha encontrada',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? TColors.darkTextSecondary
                          : TColors.textSecondary,
                    ),
              ),
            );
          }
          return ListView.separated(
            itemCount: lines.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              indent: 72,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.06),
            ),
            itemBuilder: (context, index) => LineTile(
              line: lines[index],
              isDark: isDark,
            ),
          );
        }),
      ),
    );
  }
}
