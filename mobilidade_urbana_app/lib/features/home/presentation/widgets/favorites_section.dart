import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/trip_favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/controllers/trip_favorite_controller.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/widgets/favorite_form_bottom_sheet.dart' show TripFavoriteFormBottomSheet;
import 'package:mobilidade_urbana_app/features/travel/presentation/controllers/travel_controller.dart';
import 'package:mobilidade_urbana_app/navigation_menu.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

class FavoritesSection extends ConsumerWidget {
  const FavoritesSection({super.key});

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const TripFavoriteFormBottomSheet(),
    );
  }

  void _openFavoritesScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripState = ref.watch(tripFavoriteProvider);
    final top3 = tripState.trips.take(3).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: TSizes.xs),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Favoritos',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: () => _openAddSheet(context),
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: 'Novo destino',
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => _openFavoritesScreen(context),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Row(
                        children: [
                          Text('Ver todos'),
                          SizedBox(width: 2),
                          Icon(Icons.keyboard_arrow_right, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            if (tripState.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: TSizes.lg),
                child: CircularProgressIndicator(color: TColors.primary),
              )
            else if (top3.isEmpty)
              _EmptySection(onAdd: () => _openAddSheet(context))
            else
              ...top3.map(
                (trip) => _FavoriteCard(
                  trip: trip,
                  isDark: isDark,
                  onTap: () {
                    // Converte para FavoriteEntity que o travel_screen espera
                    ref.read(travelDestinationProvider.notifier).state =
                        FavoriteEntity(
                      favoriteName: trip.name,
                      address: trip.address,
                    );
                    // Passa lat/lng já resolvido — evita geocoding
                    ref.read(travelDestinationLatLngProvider.notifier).state =
                        LatLng(trip.destinationLatitude, trip.destinationLongitude);
                    ref.read(navigationMenuProvider.notifier).onTabChanged(1);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptySection({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
      child: Column(
        children: [
          Icon(Icons.star_border_rounded, size: 40, color: Colors.grey[400]),
          const SizedBox(height: TSizes.xs),
          Text(
            'Nenhum favorito ainda',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: TColors.grey),
          ),
          const SizedBox(height: TSizes.sm),
          FilledButton.icon(

            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Adicionar favorito'),
            style: FilledButton.styleFrom(
              backgroundColor: TColors.soothingLime,
              foregroundColor: TColors.textPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
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

class _FavoriteCard extends StatelessWidget {
  final TripFavoriteEntity trip;
  final bool isDark;
  final VoidCallback onTap;

  const _FavoriteCard({
    required this.trip,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.xs),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TSizes.sm,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isDark ? TColors.darkSurface : TColors.surface,
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? TColors.darkBackground : TColors.lightGrey,
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                ),
                child: Icon(
                  Icons.place_rounded,
                  color: isDark ? TColors.light : TColors.dark,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (trip.address != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        trip.address!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: TColors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: TColors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
