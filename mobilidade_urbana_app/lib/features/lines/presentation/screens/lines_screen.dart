import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

// ── Modelo de dados ───────────────────────────────────────────────────────────

enum LineType { bus, metro, train }

class TransitLine {
  final String code;
  final String name;
  final LineType type;
  final Color color;
  final bool isFavorite;

  const TransitLine({
    required this.code,
    required this.name,
    required this.type,
    required this.color,
    this.isFavorite = false,
  });
}

// ── Dados mock ────────────────────────────────────────────────────────────────

const _mockLines = [
  TransitLine(code: '809H-10', name: 'Jardim Boa Vista - Lapa',      type: LineType.bus,   color: Color(0xFFFF6B00), isFavorite: true),
  TransitLine(code: '748A-41', name: 'Jardim Peri Peri - Lapa',      type: LineType.bus,   color: Color(0xFFFF6B00), isFavorite: true),
  TransitLine(code: '107A-10', name: 'Lapa - Metrô Santana',         type: LineType.bus,   color: Color(0xFFFF6B00)),
  TransitLine(code: '251P-10', name: 'Pinheiros - Metrô Ana Rosa',   type: LineType.bus,   color: Color(0xFFFF6B00)),
  TransitLine(code: '675A-10', name: 'Itaim Paulista - Sé',          type: LineType.bus,   color: Color(0xFFFF6B00)),
  TransitLine(code: '1',       name: 'Linha Azul - Jabaquara',       type: LineType.metro, color: Color(0xFF0057A8), isFavorite: true),
  TransitLine(code: '2',       name: 'Linha Verde - Vila Madalena',  type: LineType.metro, color: Color(0xFF007A47)),
  TransitLine(code: '3',       name: 'Linha Vermelha - Palmeiras',   type: LineType.metro, color: Color(0xFFE30613)),
  TransitLine(code: '4',       name: 'Linha Amarela - Butantã',      type: LineType.metro, color: Color(0xFFFFCC00)),
  TransitLine(code: '5',       name: 'Linha Lilás - Capão Redondo',  type: LineType.metro, color: Color(0xFF9B5EA2)),
  TransitLine(code: '7',       name: 'Linha Rubi - Jundiaí',         type: LineType.train, color: Color(0xFFBE1E2D)),
  TransitLine(code: '8',       name: 'Linha Diamante - Amador Bueno',type: LineType.train, color: Color(0xFF9E9E9E)),
  TransitLine(code: '9',       name: 'Linha Esmeralda - Osasco',     type: LineType.train, color: Color(0xFF00A651), isFavorite: true),
  TransitLine(code: '10',      name: 'Linha Turquesa - Rio Grande',  type: LineType.train, color: Color(0xFF009BA5)),
  TransitLine(code: '11',      name: 'Linha Coral - Estudantes',     type: LineType.train, color: Color(0xFFE05206)),
  TransitLine(code: '12',      name: 'Linha Safira - Calmon Viana',  type: LineType.train, color: Color(0xFF003893)),
  TransitLine(code: '13',      name: 'Linha Jade - Aeroporto',       type: LineType.train, color: Color(0xFF00884A)),
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

  static const _tabs = ['Favoritos', 'Todos', 'Ônibus', 'Trem', 'Metrô'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.toLowerCase());
    });
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
      case 0:
        base = _mockLines.where((l) => l.isFavorite).toList();
      case 2:
        base = _mockLines.where((l) => l.type == LineType.bus).toList();
      case 3:
        base = _mockLines.where((l) => l.type == LineType.train).toList();
      case 4:
        base = _mockLines.where((l) => l.type == LineType.metro).toList();
      default:
        base = _mockLines;
    }

    if (_query.isEmpty) return base;
    return base
        .where((l) =>
            l.code.toLowerCase().contains(_query) ||
            l.name.toLowerCase().contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final bg = isDark ? TColors.darkBackground : TColors.background;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: TSizes.lg),
            _SearchBar(controller: _searchController, isDark: isDark),
            SizedBox(height: TSizes.spaceBtwSections),
            _FilterTabs(controller: _tabController, isDark: isDark),
            const Divider(height: 1),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(
                  _tabs.length,
                  (i) => _LinesList(
                    lines: _filtered(i),
                    isDark: isDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;

  const _SearchBar({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? TColors.darkSurface : TColors.lightGrey;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.md,
        vertical: TSizes.xs,
      ),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        ),
        padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: isDark ? TColors.darkTextSecondary : TColors.textSecondary,
              size: TSizes.iconMd,
            ),
            const SizedBox(width: TSizes.xs),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Pesquise uma linha',
                  border: InputBorder.none,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? TColors.darkTextSecondary
                            : TColors.textSecondary,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tabs de filtro ────────────────────────────────────────────────────────────

class _FilterTabs extends StatelessWidget {
  final TabController controller;
  final bool isDark;

  const _FilterTabs({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      indicatorColor: TColors.primary,
      indicatorWeight: 3,
      labelColor: TColors.primary,
      unselectedLabelColor:
          isDark ? TColors.darkTextSecondary : TColors.textSecondary,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      unselectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
      tabs: const [
        Tab(text: 'Favoritos'),
        Tab(text: 'Todos'),
        Tab(text: 'Ônibus'),
        Tab(text: 'Trem'),
        Tab(text: 'Metrô'),
      ],
    );
  }
}

// ── Lista de linhas ───────────────────────────────────────────────────────────

class _LinesList extends StatelessWidget {
  final List<TransitLine> lines;
  final bool isDark;

  const _LinesList({required this.lines, required this.isDark});

  @override
  Widget build(BuildContext context) {
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
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.06),
      ),
      itemBuilder: (context, index) => _LineTile(
        line: lines[index],
        isDark: isDark,
      ),
    );
  }
}

// ── Tile de linha ─────────────────────────────────────────────────────────────

class _LineTile extends StatelessWidget {
  final TransitLine line;
  final bool isDark;

  const _LineTile({required this.line, required this.isDark});

  IconData get _icon {
    switch (line.type) {
      case LineType.bus:
        return Icons.directions_bus_outlined;
      case LineType.metro:
        return Icons.subway_outlined;
      case LineType.train:
        return Icons.train_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TSizes.md,
          vertical: TSizes.sm,
        ),
        child: Row(
          children: [
            // Ícone com borda colorida na base
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _icon,
                  size: 26,
                  color: isDark ? TColors.white : TColors.dark,
                ),
                const SizedBox(height: 3),
                Container(
                  width: 26,
                  height: 3,
                  decoration: BoxDecoration(
                    color: line.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            const SizedBox(width: TSizes.md),

            // Código + nome
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.code,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    line.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? TColors.darkTextSecondary
                              : TColors.textSecondary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: TColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
