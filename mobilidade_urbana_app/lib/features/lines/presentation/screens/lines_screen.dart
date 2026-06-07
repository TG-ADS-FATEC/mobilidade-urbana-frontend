import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/controllers/favorite_controller.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';
import 'package:mobilidade_urbana_app/features/lines/presentation/controllers/lines_controller.dart';
import 'package:mobilidade_urbana_app/features/lines/presentation/widgets/line_widgets.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

// ── Tela ──────────────────────────────────────────────────────────────────────

class LinesScreen extends ConsumerStatefulWidget {
  const LinesScreen({super.key});

  @override
  ConsumerState<LinesScreen> createState() => _LinesScreenState();
}

class _LinesScreenState extends ConsumerState<LinesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _searchController = TextEditingController();
    _searchController.addListener(() {
      ref.read(linesControllerProvider.notifier).onQueryChanged(_searchController.text);
    });
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 300) {
      ref.read(linesControllerProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<LineEntity> _filtered(LinesState linesState, int tabIndex, Set<String> favRouteIds) {
    switch (tabIndex) {
      case 0:  return linesState.allLines.where((l) => favRouteIds.contains(l.id)).toList();
      case 1:  return linesState.allLines;
      case 2:  return linesState.busLines;
      case 3:  return linesState.trainLines;
      case 4:  return linesState.metroLines;
      default: return linesState.allLines;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final linesState = ref.watch(linesControllerProvider);
    final favState = ref.watch(favoriteControllerProvider);
    final favRouteIds = favState.favorites.map((f) => f.routeId ?? '').toSet();
    final allLines = linesState.allLines;

    final hintColor =
        isDark ? TColors.darkTextSecondary : TColors.textSecondary;
    final fieldBg = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.05);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? TColors.dark : TColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: TSizes.md,
        title: const Text(
          'Linhas',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52 + 46),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    TSizes.md, 0, TSizes.md, TSizes.xs),
                child: SizedBox(
                  height: 48,
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(
                        fontSize: 14,
                        color: isDark ? TColors.white : TColors.dark),
                    decoration: InputDecoration(
                      hintText: 'Buscar linha ou código...',
                      hintStyle: TextStyle(fontSize: 14, color: hintColor),
                      prefixIcon:
                          Icon(Icons.search, size: 20, color: hintColor),
                      suffixIcon: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _searchController,
                        builder: (_, value, __) => value.text.isEmpty
                            ? const SizedBox.shrink()
                            : GestureDetector(
                                onTap: _searchController.clear,
                                child: Icon(Icons.close,
                                    size: 18, color: hintColor),
                              ),
                      ),
                      filled: true,
                      fillColor: fieldBg,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(TSizes.inputFieldRadius),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelStyle: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w400),
                labelColor: isDark ? TColors.white : TColors.dark,
                unselectedLabelColor: hintColor,
                indicatorColor: isDark ? TColors.white : TColors.dark,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.08),
                padding:
                    const EdgeInsets.symmetric(horizontal: TSizes.xs),
                tabs: const [
                  Tab(text: 'Favoritos'),
                  Tab(text: 'Todos'),
                  Tab(text: 'Ônibus'),
                  Tab(text: 'Trem'),
                  Tab(text: 'Metrô'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: switch ((linesState.isLoading, linesState.errorMessage)) {
        (true, _) => const Center(child: CircularProgressIndicator()),
        (_, final String msg?) => _ErrorBody(
            message: msg,
            isDark: isDark,
            onRetry: () => ref.read(linesControllerProvider.notifier).loadLines(),
          ),
        _ => TabBarView(
            controller: _tabController,
            children: List.generate(5, (i) {
              final lines = _filtered(linesState, i, favRouteIds);

              if (lines.isEmpty) {
                if (i == 0) {
                  return _FavoritesEmptyState(isDark: isDark);
                }
                return Center(
                  child: Text(
                    'Nenhuma linha encontrada',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? TColors.darkTextSecondary
                              : TColors.textSecondary,
                        ),
                  ),
                );
              }
              final showFooter = linesState.isLoadingMore && i == 1;
              return ListView.separated(
                controller: i == 1 ? _scrollController : null,
                itemCount: lines.length + (showFooter ? 1 : 0),
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  indent: 72,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.06),
                ),
                itemBuilder: (context, index) {
                  if (showFooter && index == lines.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return LineTile(
                    line: lines[index],
                    isDark: isDark,
                    onTap: () => context.push('/lines/${lines[index].id}', extra: lines[index]),
                  );
                },
              );
            }),
          ),
      },
    );
  }
}

// ── Empty state de favoritos ──────────────────────────────────────────────────

class _FavoritesEmptyState extends StatelessWidget {
  final bool isDark;
  const _FavoritesEmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final secondary = isDark ? TColors.darkTextSecondary : TColors.textSecondary;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_border_rounded, size: 64, color: secondary),
            const SizedBox(height: TSizes.sm),
            Text(
              'Nenhuma linha favorita',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: TSizes.xs),
            Text(
              'Abra uma linha e toque na estrela\npara adicioná-la aos favoritos.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: secondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Estado de erro ─────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  final String message;
  final bool isDark;
  final VoidCallback onRetry;

  const _ErrorBody({
    required this.message,
    required this.isDark,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = isDark ? TColors.darkTextSecondary : TColors.textSecondary;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 48, color: secondary),
            const SizedBox(height: TSizes.sm),
            Text(
              'Não foi possível carregar as linhas',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.xs),
            Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: secondary),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: TSizes.md),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

