import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/features/lines/data/transit_line.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

// ── Tile de linha (lista vertical) ────────────────────────────────────────────

class LineTile extends StatelessWidget {
  final TransitLine line;
  final bool isDark;
  final VoidCallback? onTap;

  const LineTile({
    super.key,
    required this.line,
    required this.isDark,
    this.onTap,
  });

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
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TSizes.md,
          vertical: TSizes.sm,
        ),
        child: Row(
          children: [
            // Ícone com barra colorida embaixo
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
            const Icon(Icons.chevron_right, color: TColors.grey),
          ],
        ),
      ),
    );
  }
}

// ── Card de linha (scroll horizontal) ────────────────────────────────────────

class LineCard extends StatelessWidget {
  final TransitLine line;
  final VoidCallback? onTap;

  const LineCard({super.key, required this.line, this.onTap});

  IconData get _icon {
    switch (line.type) {
      case LineType.bus:   return Icons.directions_bus;
      case LineType.metro: return Icons.subway;
      case LineType.train: return Icons.train;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}

// ── Chip de filtro por tipo ───────────────────────────────────────────────────

class LineFilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  const LineFilterChip({
    super.key,
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
