import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/stop_entity.dart';
import 'package:mobilidade_urbana_app/features/lines/presentation/controllers/line_detail_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class LineDetailScreen extends ConsumerWidget {
  final LineEntity line;

  const LineDetailScreen({super.key, required this.line});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = THelperFunctions.isDarkMode(context);
    final detailState = ref.watch(lineDetailProvider(line));
    final lineColor = Color(line.colorValue);
    final textColor = Color(line.textColorValue);

    // Para metrô/trem usa paradas locais; para ônibus usa state da API
    final stops = line.type != LineType.bus
        ? (line.stops ?? []).map((name) => StopEntity(id: name, name: name)).toList()
        : detailState.stops;

    final operatorLabel = _operatorName(line.agencyId);
    final typeLabel = _typeLabel(line.type);
    final typeIcon = _typeIcon(line.type);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── AppBar colorida ────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: lineColor,
            iconTheme: IconThemeData(color: textColor),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: lineColor,
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(typeIcon, color: textColor.withValues(alpha: 0.8), size: 18),
                        const SizedBox(width: 6),
                        Text(
                          typeLabel,
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (operatorLabel != null) ...[
                          Text(
                            '  ·  $operatorLabel',
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.7),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      line.code,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      line.name,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.9),
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Corpo ──────────────────────────────────────────────────────────
          if (detailState.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (detailState.errorMessage != null)
            SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_off_rounded,
                          size: 48,
                          color: isDark
                              ? TColors.darkTextSecondary
                              : TColors.textSecondary),
                      const SizedBox(height: TSizes.sm),
                      Text(
                        'Não foi possível carregar as paradas',
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
            // Cabeçalho da seção de paradas
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    TSizes.md, TSizes.md, TSizes.md, TSizes.xs),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: lineColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${stops.length} paradas',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            // Lista de paradas
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final stop = stops[index];
                  final isFirst = index == 0;
                  final isLast = index == stops.length - 1;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Linha vertical + círculo
                          SizedBox(
                            width: 24,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: isFirst
                                        ? Colors.transparent
                                        : lineColor.withValues(alpha: 0.4),
                                  ),
                                ),
                                Container(
                                  width: isFirst || isLast ? 14 : 10,
                                  height: isFirst || isLast ? 14 : 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isFirst || isLast
                                        ? lineColor
                                        : lineColor.withValues(alpha: 0.5),
                                    border: Border.all(
                                      color: lineColor,
                                      width: isFirst || isLast ? 2 : 1.5,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: isLast
                                        ? Colors.transparent
                                        : lineColor.withValues(alpha: 0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: TSizes.sm),
                          // Nome e descrição
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stop.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: isFirst || isLast
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                        ),
                                  ),
                                  if (stop.description != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      stop.description!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: isDark
                                                ? TColors.darkTextSecondary
                                                : TColors.textSecondary,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: stops.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: TSizes.lg)),
          ],
        ],
      ),
    );
  }

  String? _operatorName(String? agencyId) => switch (agencyId) {
        'METRO' => 'Metrô SP',
        'VIAQUATRO' => 'ViaQuatro',
        'VIAMOBILIDADE' => 'ViaMobilidade',
        'CPTM' => 'CPTM',
        'TIC_TRENS' => 'TIC Trens',
        '1' => 'SPTrans',
        _ => agencyId,
      };

  String _typeLabel(LineType type) => switch (type) {
        LineType.metro => 'Metrô',
        LineType.train => 'Trem',
        LineType.bus => 'Ônibus',
      };

  IconData _typeIcon(LineType type) => switch (type) {
        LineType.metro => Icons.subway_outlined,
        LineType.train => Icons.train_outlined,
        LineType.bus => Icons.directions_bus_outlined,
      };
}
