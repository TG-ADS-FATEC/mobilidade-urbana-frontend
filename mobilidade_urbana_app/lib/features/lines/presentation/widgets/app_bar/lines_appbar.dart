import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/device/device_utility.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class TLinesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TLinesAppBar({
    super.key,
    required this.tabController,
    required this.searchController,
    required this.isDark,
  });

  final TabController tabController;
  final TextEditingController searchController;
  final bool isDark;

  static const _searchBarHeight = 52.0;
  static const _tabBarHeight = 46.0;

  @override
  Size get preferredSize => Size.fromHeight(
        TDeviceUtils.getAppBarHeight() + _searchBarHeight + _tabBarHeight,
      );

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? TColors.dark : TColors.white;
    final iconColor = isDark ? TColors.white : TColors.dark;
    final hintColor =
        isDark ? TColors.darkTextSecondary : TColors.textSecondary;
    final fieldBg = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.05);

    return AppBar(
      backgroundColor: bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: TSizes.md,
      title: const Text(
        'Linhas',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(_searchBarHeight + _tabBarHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barra de pesquisa
            Padding(
              padding: const EdgeInsets.fromLTRB(
                TSizes.md,
                0,
                TSizes.md,
                TSizes.xs,
              ),
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: searchController,
                  style: TextStyle(
                    fontSize: 14,
                    color: iconColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar linha ou código...',
                    hintStyle: TextStyle(fontSize: 14, color: hintColor),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: hintColor,
                    ),
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: searchController,
                      builder: (_, value, __) => value.text.isEmpty
                          ? const SizedBox.shrink()
                          : GestureDetector(
                              onTap: searchController.clear,
                              child: Icon(Icons.close, size: 18, color: hintColor),
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

            // TabBar
            TabBar(
              controller: tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              labelColor: iconColor,
              unselectedLabelColor: hintColor,
              indicatorColor: iconColor,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.08),
              padding: const EdgeInsets.symmetric(horizontal: TSizes.xs),
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
    );
  }
}
