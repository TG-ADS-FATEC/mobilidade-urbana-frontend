import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/features/lines/data/transit_line.dart';
import 'package:mobilidade_urbana_app/features/lines/presentation/widgets/line_widgets.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

// ── Dados mock de linhas próximas ─────────────────────────────────────────────

const _nearbyLines = [
  TransitLine(code: '8086-10', name: 'Pinheiros\nCircular',             type: LineType.bus,   color: Color(0xFFFF6B00)),
  TransitLine(code: '8019-31', name: 'Term. Vi Sônia\nPq. Continental', type: LineType.bus,   color: Color(0xFFFF6B00)),
  TransitLine(code: 'Linha 9', name: 'Ceasa\nGrajaú',                  type: LineType.train, color: Color(0xFF00A651)),
  TransitLine(code: '8031-10', name: 'Lapa\nPq. Continental',          type: LineType.bus,   color: Color(0xFFFF6B00)),
  TransitLine(code: '1',       name: 'Jabaquara\nTucuruvi',            type: LineType.metro, color: Color(0xFF0057A8)),
  TransitLine(code: '2',       name: 'Vila Madalena\nVila Prudente',   type: LineType.metro, color: Color(0xFF007A47)),
  TransitLine(code: '107A-10', name: 'Lapa\nMetrô Santana',            type: LineType.bus,   color: Color(0xFFFF6B00)),
  TransitLine(code: '251P-10', name: 'Pinheiros\nMetrô Ana Rosa',      type: LineType.bus,   color: Color(0xFFFF6B00)),
  TransitLine(code: '3',       name: 'Palmeiras\nCorinthians',         type: LineType.metro, color: Color(0xFFE30613)),
  TransitLine(code: 'Linha 7', name: 'Luz\nJundiaí',                   type: LineType.train, color: Color(0xFFBE1E2D)),
];

// ── Bottom sheet "Ver todos" ──────────────────────────────────────────────────

void showNearbyLinesSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _NearbyLinesSheet(),
  );
}

class _NearbyLinesSheet extends StatefulWidget {
  const _NearbyLinesSheet();

  @override
  State<_NearbyLinesSheet> createState() => _NearbyLinesSheetState();
}

class _NearbyLinesSheetState extends State<_NearbyLinesSheet> {
  final Set<LineType> _active = {LineType.bus, LineType.train, LineType.metro};

  List<TransitLine> get _filtered => _nearbyLines
      .where((l) => _active.contains(l.type))
      .toList();

  void _toggle(LineType type) {
    setState(() {
      if (_active.contains(type)) {
        if (_active.length > 1) _active.remove(type);
      } else {
        _active.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  TSizes.md, TSizes.sm, TSizes.md, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: TSizes.sm),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nas proximidades',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        '${_filtered.length} linhas',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: TColors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.sm),
                  Row(
                    children: [
                      LineFilterChip(
                        label: 'Ônibus',
                        icon: Icons.directions_bus,
                        selected: _active.contains(LineType.bus),
                        onTap: () => _toggle(LineType.bus),
                        isDark: isDark,
                      ),
                      const SizedBox(width: TSizes.xs),
                      LineFilterChip(
                        label: 'Trem',
                        icon: Icons.train,
                        selected: _active.contains(LineType.train),
                        onTap: () => _toggle(LineType.train),
                        isDark: isDark,
                      ),
                      const SizedBox(width: TSizes.xs),
                      LineFilterChip(
                        label: 'Metrô',
                        icon: Icons.subway,
                        selected: _active.contains(LineType.metro),
                        onTap: () => _toggle(LineType.metro),
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.xs),
                  const Divider(height: 1),
                ],
              ),
            ),
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma linha encontrada',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: TColors.grey),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding:
                          const EdgeInsets.symmetric(vertical: TSizes.xs),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        indent: 72,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.black.withValues(alpha: 0.06),
                      ),
                      itemBuilder: (context, index) => LineTile(
                        line: _filtered[index],
                        isDark: isDark,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ── Seção da home ─────────────────────────────────────────────────────────────

class NearbyVehicles extends StatefulWidget {
  const NearbyVehicles({super.key});

  @override
  State<NearbyVehicles> createState() => _NearbyVehiclesState();
}

class _NearbyVehiclesState extends State<NearbyVehicles> {
  final Set<LineType> _active = {LineType.bus, LineType.train};

  List<TransitLine> get _filtered => _nearbyLines
      .where((l) => _active.contains(l.type))
      .toList();

  void _toggle(LineType type) {
    setState(() {
      if (_active.contains(type)) {
        if (_active.length > 1) _active.remove(type);
      } else {
        _active.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nas proximidades',
                    style: Theme.of(context).textTheme.titleMedium),
                TextButton(
                  onPressed: () => showNearbyLinesSheet(context),
                  style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact),
                  child: const Row(
                    children: [
                      Text('Ver todos'),
                      SizedBox(width: 2),
                      Icon(Icons.keyboard_arrow_down, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.xs),
            Row(
              children: [
                LineFilterChip(
                  label: 'Ônibus',
                  icon: Icons.directions_bus,
                  selected: _active.contains(LineType.bus),
                  onTap: () => _toggle(LineType.bus),
                  isDark: isDark,
                ),
                const SizedBox(width: TSizes.xs),
                LineFilterChip(
                  label: 'Trem',
                  icon: Icons.train,
                  selected: _active.contains(LineType.train),
                  onTap: () => _toggle(LineType.train),
                  isDark: isDark,
                ),
                const SizedBox(width: TSizes.xs),
                LineFilterChip(
                  label: 'Metrô',
                  icon: Icons.subway,
                  selected: _active.contains(LineType.metro),
                  onTap: () => _toggle(LineType.metro),
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            SizedBox(
              height: 120,
              child: _filtered.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma linha nas proximidades',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: TColors.grey),
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: TSizes.xs),
                      itemBuilder: (context, index) =>
                          LineCard(line: _filtered[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
