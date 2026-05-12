import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/controllers/favorite_controller.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/widgets/favorite_form_bottom_sheet.dart';
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
      builder: (_) => const FavoriteFormBottomSheet(),
    );
  }

  void _openFavoritesScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favState = ref.watch(favoriteControllerProvider);
    final top3 = favState.topFavorites;
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
                      tooltip: 'Novo favorito',
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

            if (favState.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: TSizes.lg),
                child: CircularProgressIndicator(color: TColors.primary),
              )
            else if (top3.isEmpty)
              _EmptySection(onAdd: () => _openAddSheet(context))
            else
              ...top3.map(
                (fav) => _FavoriteCard(
                  favorite: fav,
                  isDark: isDark,
                  onTap: () {
                    ref.read(travelDestinationProvider.notifier).state = fav;
                    ref
                        .read(navigationMenuProvider.notifier)
                        .onTabChanged(1);
                    if (fav.favoriteId != null) {
                      ref
                          .read(favoriteControllerProvider.notifier)
                          .incrementUsage(fav.favoriteId!);
                    }
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
  final FavoriteEntity favorite;
  final bool isDark;
  final VoidCallback onTap;

  const _FavoriteCard({
    required this.favorite,
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
                  Icons.star_rounded,
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
                      favorite.favoriteName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (favorite.address != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        favorite.address!,
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
