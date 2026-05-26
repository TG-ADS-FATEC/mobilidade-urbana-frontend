import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/features/lines/presentation/screens/lines_screen.dart';
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

  List<TransitLine> get _filtered => _active.isEmpty
      ? _nearbyLines
      : _nearbyLines.where((l) => _active.contains(l.type)).toList();

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
            // ── Handle + cabeçalho ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(TSizes.md, TSizes.sm, TSizes.md, 0),
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${_filtered.length} linhas',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: TColors.grey,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.sm),

                  // ── Chips ──────────────────────────────────────────────
                  Row(
                    children: [
                      _FilterChip(
                        label: 'Ônibus',
                        icon: Icons.directions_bus,
                        selected: _active.contains(LineType.bus),
                        onTap: () => _toggle(LineType.bus),
                        isDark: isDark,
                      ),
                      const SizedBox(width: TSizes.xs),
                      _FilterChip(
                        label: 'Trem',
                        icon: Icons.train,
                        selected: _active.contains(LineType.train),
                        onTap: () => _toggle(LineType.train),
                        isDark: isDark,
                      ),
                      const SizedBox(width: TSizes.xs),
                      _FilterChip(
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

            // ── Lista ────────────────────────────────────────────────────
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma linha encontrada',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: TColors.grey,
                            ),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        indent: 72,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.black.withValues(alpha: 0.06),
                      ),
                      itemBuilder: (context, index) => _LineTile(
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

// ── Tile da lista ─────────────────────────────────────────────────────────────

class _LineTile extends StatelessWidget {
  final TransitLine line;
  final bool isDark;

  const _LineTile({required this.line, required this.isDark});

  IconData get _icon {
    switch (line.type) {
      case LineType.bus:   return Icons.directions_bus_outlined;
      case LineType.metro: return Icons.subway_outlined;
      case LineType.train: return Icons.train_outlined;
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
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: line.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
              ),
              child: Icon(_icon, color: line.color, size: 22),
            ),
            const SizedBox(width: TSizes.sm),
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
                  Text(
                    line.name.replaceAll('\n', ' — '),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: line.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(TSizes.buttonRadius),
              ),
              child: Text(
                line.type == LineType.bus
                    ? 'Ônibus'
                    : line.type == LineType.metro
                        ? 'Metrô'
                        : 'Trem',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: line.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widget principal da seção ─────────────────────────────────────────────────

class NearbyVehicles extends StatefulWidget {
  const NearbyVehicles({super.key});

  @override
  State<NearbyVehicles> createState() => _NearbyVehiclesState();
}

class _NearbyVehiclesState extends State<NearbyVehicles> {
  final Set<LineType> _active = {LineType.bus, LineType.train};

  List<TransitLine> get _filtered => _active.isEmpty
      ? _nearbyLines
      : _nearbyLines.where((l) => _active.contains(l.type)).toList();

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
            // ── Cabeçalho ──────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nas proximidades',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () => showNearbyLinesSheet(context),
                  style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
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

            // ── Chips de filtro ────────────────────────────────────────────
            Row(
              children: [
                _FilterChip(
                  label: 'Ônibus',
                  icon: Icons.directions_bus,
                  selected: _active.contains(LineType.bus),
                  onTap: () => _toggle(LineType.bus),
                  isDark: isDark,
                ),
                const SizedBox(width: TSizes.xs),
                _FilterChip(
                  label: 'Trem',
                  icon: Icons.train,
                  selected: _active.contains(LineType.train),
                  onTap: () => _toggle(LineType.train),
                  isDark: isDark,
                ),
                const SizedBox(width: TSizes.xs),
                _FilterChip(
                  label: 'Metrô',
                  icon: Icons.subway,
                  selected: _active.contains(LineType.metro),
                  onTap: () => _toggle(LineType.metro),
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // ── Cards horizontais ──────────────────────────────────────────
            SizedBox(
              height: 120,
              child: _filtered.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma linha nas proximidades',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: TColors.grey,
                            ),
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(width: TSizes.xs),
                      itemBuilder: (context, index) =>
                          _LineCard(line: _filtered[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Chip de filtro ────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? (isDark ? TColors.light : TColors.dark)
        : Colors.transparent;
    final fg = selected
        ? (isDark ? TColors.dark : TColors.light)
        : (isDark ? TColors.darkTextSecondary : TColors.textSecondary);
    final border = selected
        ? Colors.transparent
        : (isDark
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.black.withValues(alpha: 0.2));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(TSizes.buttonRadius),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Card de linha ─────────────────────────────────────────────────────────────

class _LineCard extends StatelessWidget {
  final TransitLine line;

  const _LineCard({required this.line});

  IconData get _icon {
    switch (line.type) {
      case LineType.bus:   return Icons.directions_bus;
      case LineType.metro: return Icons.subway;
      case LineType.train: return Icons.train;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: line.color,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon, color: Colors.white, size: 22),
          const Spacer(),
          Text(
            line.code,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            line.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
