import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/controllers/favorite_controller.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/stop_entity.dart';
import 'package:mobilidade_urbana_app/features/lines/presentation/controllers/line_detail_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class LineDetailScreen extends ConsumerStatefulWidget {
  final LineEntity line;

  const LineDetailScreen({super.key, required this.line});

  @override
  ConsumerState<LineDetailScreen> createState() => _LineDetailScreenState();
}

class _LineDetailScreenState extends ConsumerState<LineDetailScreen> {
  LineEntity get line => widget.line;

  final _mapKey = GlobalKey<_RouteMapState>();
  final _pageScrollController = ScrollController();
  final _stopKeys = <String, GlobalKey>{};
  String? _selectedStopId;

  @override
  void dispose() {
    _pageScrollController.dispose();
    super.dispose();
  }

  void _onStopSelected(StopEntity stop) {
    setState(() => _selectedStopId = stop.id);
    // Move o mapa para a parada
    _mapKey.currentState?.moveToStop(stop);
    // Rola a lista para o item
    final key = _stopKeys[stop.id];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );
    }
  }

  Future<void> _toggleFavorite(FavoriteEntity? existing) async {
    final messenger = ScaffoldMessenger.of(context);
    final notifier = ref.read(favoriteControllerProvider.notifier);
    final removing = existing != null;

    if (removing) {
      await notifier.deleteFavorite(existing.favoriteId!);
    } else {
      await notifier.addFavorite(FavoriteEntity(
        routeId: line.id,
        favoriteName: line.name,
        shortName: line.code,
        routeType: switch (line.type) {
          LineType.bus   => 'BUS',
          LineType.metro => 'METRO',
          LineType.train => 'TRAIN',
        },
      ));
    }

    if (!mounted) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgSuccess = isDark ? const Color(0xFF2C2C2C) : TColors.dark;
    const contentColor = TColors.white;

    final error = ref.read(favoriteControllerProvider).errorMessage;
    if (error != null) {
      messenger.showSnackBar(SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: contentColor, size: 18),
            const SizedBox(width: TSizes.xs),
            Expanded(
              child: Text(error, style: const TextStyle(color: contentColor)),
            ),
          ],
        ),
        backgroundColor: TColors.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(TSizes.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
        ),
      ));
      return;
    }

    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(
            removing ? Icons.star_border_rounded : Icons.star_rounded,
            color: removing ? Colors.grey[400] : TColors.soothingLime,
            size: 18,
          ),
          const SizedBox(width: TSizes.xs),
          Expanded(
            child: Text(
              removing
                  ? '${line.code} removida dos favoritos'
                  : '${line.code} adicionada aos favoritos',
              style: const TextStyle(color: contentColor),
            ),
          ),
        ],
      ),
      backgroundColor: bgSuccess,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(TSizes.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
      ),
      duration: const Duration(seconds: 3),
      action: removing
          ? SnackBarAction(
              label: 'Desfazer',
              textColor: TColors.soothingLime,
              onPressed: () async {
                await notifier.addFavorite(FavoriteEntity(
                  routeId: line.id,
                  favoriteName: line.name,
                  shortName: line.code,
                  routeType: switch (line.type) {
                    LineType.bus   => 'BUS',
                    LineType.metro => 'METRO',
                    LineType.train => 'TRAIN',
                  },
                ));
              },
            )
          : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final detailState = ref.watch(lineDetailProvider(line));
    final favState = ref.watch(favoriteControllerProvider);
    final lineColor = Color(line.colorValue);
    final textColor = Color(line.textColorValue);

    final existingFav = favState.favorites
        .where((f) => f.routeId == line.id)
        .firstOrNull;
    final isFavorited = existingFav != null;
    final isFavLoading = favState.isLoading;

    // Para metrô/trem usa paradas locais; para ônibus usa o trip selecionado da API.
    final stops = line.type != LineType.bus
        ? (line.stops ?? []).map((name) => StopEntity(id: name, name: name)).toList()
        : detailState.stops; // getter já retorna trips[selectedTrip]

    final operatorLabel = _operatorName(line.agencyId);
    final typeLabel = _typeLabel(line.type);
    final typeIcon = _typeIcon(line.type);

    return Scaffold(
      body: CustomScrollView(
        controller: _pageScrollController,
        slivers: [
          // ── AppBar colorida ────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: lineColor,
            iconTheme: IconThemeData(color: textColor),
            actions: [
              if (detailState.hasMultipleDirections)
                IconButton(
                  tooltip: 'Trocar sentido',
                  icon: Icon(Icons.swap_horiz_rounded, color: textColor),
                  onPressed: () =>
                      ref.read(lineDetailProvider(line).notifier).switchDirection(),
                ),
              isFavLoading
                  ? Padding(
                      padding: const EdgeInsets.all(14),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: textColor,
                        ),
                      ),
                    )
                  : IconButton(
                      tooltip: isFavorited ? 'Remover favorito' : 'Favoritar',
                      icon: Icon(
                        isFavorited ? Icons.star_rounded : Icons.star_border_rounded,
                        color: textColor,
                      ),
                      onPressed: () => _toggleFavorite(existingFav),
                    ),
            ],
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
            // ── Mapa da rota (apenas ônibus com coordenadas) ───────────────
            if (line.type == LineType.bus)
              SliverToBoxAdapter(
                child: _RouteMap(
                  key: _mapKey,
                  stops: stops,
                  lineColor: lineColor,
                  selectedStopId: _selectedStopId,
                  onStopTapped: _onStopSelected,
                ),
              ),

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
                    const SizedBox(width: TSizes.xs),
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
                  final isSelected = _selectedStopId == stop.id;

                  // Garante uma GlobalKey estável por parada.
                  final itemKey = _stopKeys.putIfAbsent(stop.id, () => GlobalKey());

                  final dotSize = isSelected ? 16.0 : (isFirst || isLast ? 14.0 : 10.0);
                  final dotColor = isSelected
                      ? lineColor
                      : (isFirst || isLast ? lineColor : lineColor.withValues(alpha: 0.5));

                  return GestureDetector(
                    key: itemKey,
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onStopSelected(stop),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: isSelected
                          ? lineColor.withValues(alpha: isDark ? 0.18 : 0.10)
                          : Colors.transparent,
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
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: dotSize,
                                    height: dotSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: dotColor,
                                      border: Border.all(
                                        color: lineColor,
                                        width: isSelected ? 2.5 : (isFirst || isLast ? 2 : 1.5),
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: lineColor.withValues(alpha: 0.45),
                                                blurRadius: 6,
                                                spreadRadius: 1,
                                              )
                                            ]
                                          : null,
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
                                            fontWeight: isSelected || isFirst || isLast
                                                ? FontWeight.w700
                                                : FontWeight.w400,
                                            color: isSelected ? lineColor : null,
                                          ),
                                    ),
                                    if (stop.description != null) ...[
                                      const SizedBox(height: TSizes.xxs),
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
                                    if (stop.arrivalTime != null && (isFirst || isLast)) ...[
                                      const SizedBox(height: TSizes.xxs),
                                      Text(
                                        stop.arrivalTime!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: isDark
                                                  ? TColors.darkTextSecondary
                                                  : TColors.textSecondary,
                                              fontFeatures: [const FontFeature.tabularFigures()],
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

// ── Mapa da rota ─────────────────────────────────────────────────────────────

class _RouteMap extends StatefulWidget {
  final List<StopEntity> stops;
  final Color lineColor;
  final String? selectedStopId;
  final void Function(StopEntity) onStopTapped;

  const _RouteMap({
    super.key,
    required this.stops,
    required this.lineColor,
    required this.selectedStopId,
    required this.onStopTapped,
  });

  @override
  State<_RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<_RouteMap> {
  final _mapController = MapController();

  List<StopEntity> get _stopsWithCoords =>
      widget.stops.where((s) => s.latitude != null && s.longitude != null).toList();

  List<LatLng> get _points =>
      _stopsWithCoords.map((s) => LatLng(s.latitude!, s.longitude!)).toList();

  /// Chamado pelo pai para mover a câmera até uma parada.
  void moveToStop(StopEntity stop) {
    if (stop.latitude != null && stop.longitude != null) {
      _mapController.move(LatLng(stop.latitude!, stop.longitude!), 16);
    }
  }

  @override
  void didUpdateWidget(_RouteMap old) {
    super.didUpdateWidget(old);
    // Quando o sentido muda, recentra o mapa.
    if (old.stops != widget.stops) _fitBounds();
  }

  void _fitBounds() {
    final pts = _points;
    if (pts.isEmpty) return;
    if (pts.length == 1) {
      _mapController.move(pts.first, 14);
      return;
    }
    final bounds = LatLngBounds.fromPoints(pts);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(32),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pts = _points;
    if (pts.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tileUrl = isDark
        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
        : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';

    final color = widget.lineColor;
    final terminalColor = color;
    final stopColor = color.withValues(alpha: 0.6);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(TSizes.cardRadiusLg),
      ),
      child: SizedBox(
        height: 220,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCameraFit: CameraFit.bounds(
              bounds: LatLngBounds.fromPoints(pts),
              padding: const EdgeInsets.all(32),
            ),
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom |
                  InteractiveFlag.drag |
                  InteractiveFlag.doubleTapZoom,
            ),
          ),
          children: [
            // Tiles
            TileLayer(
              urlTemplate: tileUrl,
              userAgentPackageName: 'com.mobilidade.urbana',
            ),

            // Traçado da rota
            PolylineLayer(
              polylines: [
                Polyline(
                  points: pts,
                  color: color,
                  strokeWidth: 3.5,
                ),
              ],
            ),

            // Bolinhas das paradas (tappáveis)
            MarkerLayer(
              markers: [
                for (var i = 0; i < _stopsWithCoords.length; i++)
                  _stopMarker(
                    stop: _stopsWithCoords[i],
                    point: pts[i],
                    isTerminal: i == 0 || i == _stopsWithCoords.length - 1,
                    isSelected: widget.selectedStopId == _stopsWithCoords[i].id,
                    color: color,
                  ),
              ],
            ),

            // Label nos terminais
            MarkerLayer(
              markers: [
                if (_stopsWithCoords.isNotEmpty)
                  _terminalMarker(_stopsWithCoords.first, pts.first, above: false),
                if (_stopsWithCoords.length > 1)
                  _terminalMarker(_stopsWithCoords.last, pts.last, above: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Marker _stopMarker({
    required StopEntity stop,
    required LatLng point,
    required bool isTerminal,
    required bool isSelected,
    required Color color,
  }) {
    final size = isSelected ? 22.0 : (isTerminal ? 16.0 : 10.0);
    return Marker(
      point: point,
      width: size,
      height: size,
      child: GestureDetector(
        onTap: () => widget.onStopTapped(stop),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? color
                : (isTerminal ? color : color.withValues(alpha: 0.55)),
            border: Border.all(
              color: Colors.white,
              width: isSelected ? 2.5 : 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ]
                : null,
          ),
        ),
      ),
    );
  }

  Marker _terminalMarker(StopEntity stop, LatLng point, {required bool above}) {
    return Marker(
      point: point,
      width: 160,
      height: 28,
      alignment: above ? Alignment.bottomCenter : Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.xs, vertical: TSizes.xxs),
        decoration: BoxDecoration(
          color: widget.lineColor,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          stop.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
