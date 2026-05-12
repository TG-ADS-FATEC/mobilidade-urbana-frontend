import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/core/services/permission_service.dart';
import 'package:mobilidade_urbana_app/features/home/presentation/screens/home_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:mobilidade_urbana_app/features/travel/presentation/travel_screen.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class _NavigationState {
  final int selectedIndex;
  const _NavigationState({this.selectedIndex = 0});
  _NavigationState copyWith({int? selectedIndex}) =>
      _NavigationState(selectedIndex: selectedIndex ?? this.selectedIndex);
}

class _NavigationNotifier extends Notifier<_NavigationState> {
  @override
  _NavigationState build() => const _NavigationState();

  void onTabChanged(int index) =>
      state = state.copyWith(selectedIndex: index);
}

final navigationMenuProvider =
    NotifierProvider<_NavigationNotifier, _NavigationState>(
  () => _NavigationNotifier(),
);

class NavigationMenu extends ConsumerStatefulWidget {
  const NavigationMenu({super.key});

  @override
  ConsumerState<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends ConsumerState<NavigationMenu> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) PermissionService.requestOnFirstLaunch(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(navigationMenuProvider);
    final notifier = ref.read(navigationMenuProvider.notifier);
    final isDarkMode = THelperFunctions.isDarkMode(context);

    final screens = [
      HomeScreen(),
      TravelScreen(onBack: () => notifier.onTabChanged(0)),
      Container(color: Colors.red),
      const ProfileScreen(),
    ];

    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 8),
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      (isDarkMode
                              ? TColors.darkBackground.withValues(alpha: 0.4)
                              : TColors.light)
                          .withValues(alpha: 0.4),
                      (isDarkMode
                              ? TColors.darkBackground.withValues(alpha: 0.40)
                              : TColors.light)
                          .withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDarkMode
                      ? TColors.darkSurface.withValues(alpha: 0.1)
                      : TColors.background.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: NavigationBar(
              height: 80,
              elevation: 0,
              selectedIndex: state.selectedIndex,
              onDestinationSelected: notifier.onTabChanged,
              backgroundColor:
                  isDarkMode ? TColors.darkBackground : TColors.light,
              indicatorColor: TColors.soothingLime,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Início',
                ),
                NavigationDestination(
                  icon: Icon(Icons.directions_bus_outlined),
                  selectedIcon: Icon(Icons.directions_bus),
                  label: 'Ir',
                ),
                NavigationDestination(
                  icon: Icon(Icons.more_horiz),
                  selectedIcon: Icon(Icons.more_horiz),
                  label: 'linhas',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Conta',
                ),
              ],
            ),
          ),
        ],
      ),
      body: screens[state.selectedIndex],
    );
  }
}
