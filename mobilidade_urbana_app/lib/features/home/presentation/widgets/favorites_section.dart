import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/controllers/favorite_controller.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/widgets/favorite_form_bottom_sheet.dart';
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
            // Cabeçalho com botão "+" e "Ver todos"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Favoritos',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _openAddSheet(context),
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: 'Novo favorito',
                      visualDensity: VisualDensity.compact,
                    ),
                    TextButton(
                      onPressed: () => _openFavoritesScreen(context),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Ver todos',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.keyboard_arrow_right, size: 16),
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
                child: CircularProgressIndicator(),
              )
            else if (top3.isEmpty)
              _EmptySection(onAdd: () => _openAddSheet(context))
            else
              ...top3.map(
                (fav) => _FavoriteCard(
                  favorite: fav,
                  isDark: isDark,
                  onTap: () {
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
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: TSizes.xs),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Adicionar favorito'),
            style: OutlinedButton.styleFrom(
              foregroundColor: TColors.primary,
              side: const BorderSide(color: TColors.primary),
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
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TSizes.sm,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.grey[100],
            borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: TColors.primary,
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
                            ?.copyWith(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}