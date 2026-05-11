import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/core/widgets/appbar.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/controllers/favorite_controller.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/widgets/favorite_form_bottom_sheet.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  void _openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const FavoriteFormBottomSheet(),
    );
  }

  void _openEditSheet(FavoriteEntity favorite) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FavoriteFormBottomSheet(favorite: favorite),
    );
  }

  Future<void> _confirmDelete(String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover favorito'),
        content: Text('Remover "$name" dos favoritos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Remover',
              style: TextStyle(color: TColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(favoriteControllerProvider.notifier).deleteFavorite(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final favState = ref.watch(favoriteControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: TAppBar(
        title: const Text('Favoritos'),
        showBackArrow: true,
      ),
      body: favState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : favState.favorites.isEmpty
              ? _EmptyState(onAdd: _openAddSheet)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.sm,
                    vertical: TSizes.xs,
                  ),
                  itemCount: favState.favorites.length,
                  itemBuilder: (context, index) {
                    final fav = favState.favorites[index];
                    return _FavoriteTile(
                      favorite: fav,
                      isDark: isDark,
                      onEdit: () => _openEditSheet(fav),
                      onDelete: () =>
                          _confirmDelete(fav.favoriteId!, fav.favoriteName),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSheet,
        backgroundColor: TColors.primary,
        child: const Icon(Icons.add, color: TColors.white),
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
            'Adicione seus locais favoritos\npara acesso rápido',
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
            label: const Text('Adicionar favorito'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
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

class _FavoriteTile extends StatelessWidget {
  final FavoriteEntity favorite;
  final bool isDark;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FavoriteTile({
    required this.favorite,
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
            child: const Icon(
              Icons.star_rounded,
              color: TColors.primary,
              size: 22,
            ),
          ),
          title: Text(
            favorite.favoriteName,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: favorite.address != null
              ? Text(
                  favorite.address!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
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
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: TColors.error,
                ),
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
