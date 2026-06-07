import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/core/widgets/appbar.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/trip_favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/controllers/favorite_controller.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/controllers/trip_favorite_controller.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/widgets/favorite_form_bottom_sheet.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  // ── Trip actions ──────────────────────────────────────────────────────────

  void _openAddTripSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const TripFavoriteFormBottomSheet(),
    );
  }

  void _openEditTripSheet(TripFavoriteEntity trip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => TripFavoriteFormBottomSheet(trip: trip),
    );
  }

  Future<void> _confirmDeleteTrip(String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover destino'),
        content: Text('Remover "$name" dos favoritos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remover', style: TextStyle(color: TColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(tripFavoriteProvider.notifier).deleteTrip(id);
    }
  }

  // ── Route favorite actions ─────────────────────────────────────────────────

  Future<void> _confirmDeleteRoute(String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover linha'),
        content: Text('Remover "$name" das linhas favoritas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remover', style: TextStyle(color: TColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(favoriteControllerProvider.notifier).deleteFavorite(id);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tripState = ref.watch(tripFavoriteProvider);
    final routeState = ref.watch(favoriteControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isLoading = tripState.isLoading || routeState.isLoading;
    final hasTrips = tripState.trips.isNotEmpty;
    final hasRoutes = routeState.favorites.isNotEmpty;

    return Scaffold(
      appBar: TAppBar(
        title: const Text('Favoritos'),
        showBackArrow: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTripSheet,
        backgroundColor: TColors.soothingLime,
        tooltip: 'Novo destino',
        child: const Icon(Icons.add, color: TColors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (!hasTrips && !hasRoutes)
              ? _EmptyState(onAdd: _openAddTripSheet)
              : ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.sm,
                    vertical: TSizes.xs,
                  ),
                  children: [
                    // ── Destinos ────────────────────────────────────────────
                    _SectionHeader(
                      icon: Icons.place_outlined,
                      label: 'Destinos',
                      onAdd: _openAddTripSheet,
                    ),
                    if (!hasTrips)
                      _SectionEmpty(
                        message: 'Nenhum destino favorito ainda.',
                        onAdd: _openAddTripSheet,
                        addLabel: 'Adicionar destino',
                      )
                    else
                      ...tripState.trips.map(
                        (trip) => _TripTile(
                          trip: trip,
                          isDark: isDark,
                          onEdit: () => _openEditTripSheet(trip),
                          onDelete: () =>
                              _confirmDeleteTrip(trip.id!, trip.name),
                        ),
                      ),

                    const SizedBox(height: TSizes.sm),

                    // ── Linhas ──────────────────────────────────────────────
                    _SectionHeader(
                      icon: Icons.directions_bus_outlined,
                      label: 'Linhas',
                    ),
                    if (!hasRoutes)
                      _SectionEmpty(
                        message: 'Nenhuma linha favorita ainda.',
                        hint: 'Abra uma linha e toque na estrela para salvá-la.',
                      )
                    else
                      ...routeState.favorites.map(
                        (fav) => _RouteTile(
                          favorite: fav,
                          isDark: isDark,
                          onDelete: () =>
                              _confirmDeleteRoute(fav.favoriteId!, fav.favoriteName),
                        ),
                      ),

                    const SizedBox(height: TSizes.twoXl), // espaço para FAB
                  ],
                ),
    );
  }
}

// ── Widgets auxiliares ───────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onAdd;

  const _SectionHeader({required this.icon, required this.label, this.onAdd});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(
        top: TSizes.xs,
        bottom: TSizes.xxs,
        left: TSizes.xs,
        right: TSizes.xs,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: onSurface),
          const SizedBox(width: TSizes.xxs),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: onSurface,
                ),
          ),
          const Spacer(),
          if (onAdd != null)
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Novo'),
              style: FilledButton.styleFrom(
                backgroundColor: TColors.soothingLime,
                foregroundColor: TColors.black,
                padding: const EdgeInsets.symmetric(horizontal: TSizes.xs, vertical: TSizes.xxs),
                visualDensity: VisualDensity.compact,
                textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionEmpty extends StatelessWidget {
  final String message;
  final String? hint;
  final VoidCallback? onAdd;
  final String? addLabel;

  const _SectionEmpty({
    required this.message,
    this.hint,
    this.onAdd,
    this.addLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.sm, horizontal: TSizes.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          if (hint != null) ...[
            const SizedBox(height: TSizes.xxs),
            Text(
              hint!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
            ),
          ],
          if (onAdd != null && addLabel != null) ...[
            const SizedBox(height: TSizes.xs),
            OutlinedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 16),
              label: Text(addLabel!),
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: TSizes.xs, vertical: TSizes.xxs),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TripTile extends StatelessWidget {
  final TripFavoriteEntity trip;
  final bool isDark;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TripTile({
    required this.trip,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.xs),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.grey[100],
          borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: TSizes.sm,
            vertical: TSizes.xxs,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
            ),
            child: const Icon(Icons.place_rounded, color: TColors.primary, size: 22),
          ),
          title: Text(
            trip.name,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: trip.address != null
              ? Text(
                  trip.address!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: onEdit,
                tooltip: 'Editar',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: TColors.error),
                onPressed: onDelete,
                tooltip: 'Remover',
              ),
            ],
          ),
          onTap: onEdit,
        ),
      ),
    );
  }
}

class _RouteTile extends StatelessWidget {
  final FavoriteEntity favorite;
  final bool isDark;
  final VoidCallback onDelete;

  const _RouteTile({
    required this.favorite,
    required this.isDark,
    required this.onDelete,
  });

  String get _typeLabel {
    switch (favorite.routeType?.toUpperCase()) {
      case 'METRO':
        return 'Metrô';
      case 'TRAIN':
        return 'Trem';
      default:
        return 'Ônibus';
    }
  }

  Color get _typeColor {
    switch (favorite.routeType?.toUpperCase()) {
      case 'METRO':
        return Colors.blue;
      case 'TRAIN':
        return Colors.purple;
      default:
        return TColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.xs),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.grey[100],
          borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: TSizes.sm,
            vertical: TSizes.xxs,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
            ),
            child: Icon(Icons.directions_bus_rounded, color: _typeColor, size: 22),
          ),
          title: Text(
            favorite.favoriteName,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            children: [
              if (favorite.shortName != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: TSizes.xxs, vertical: TSizes.xxs),
                  decoration: BoxDecoration(
                    color: _typeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                  ),
                  child: Text(
                    favorite.shortName!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _typeColor,
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.xxs),
              ],
              Text(
                _typeLabel,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, size: 20, color: TColors.error),
            onPressed: onDelete,
            tooltip: 'Remover',
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_border_rounded, size: 72, color: Colors.grey[400]),
          const SizedBox(height: TSizes.sm),
          Text(
            'Nenhum favorito ainda',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            'Adicione destinos para acesso rápido\nou favorite linhas na tela de rotas.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: TSizes.md),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Adicionar destino'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.black,
              foregroundColor: TColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TSizes.buttonRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
