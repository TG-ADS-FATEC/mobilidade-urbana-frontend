import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/core/widgets/search_container.dart';
import 'package:mobilidade_urbana_app/features/home/presentation/screens/search_screen.dart';
import 'package:mobilidade_urbana_app/features/home/presentation/widgets/favorites_section.dart';
import 'package:mobilidade_urbana_app/features/home/presentation/widgets/home_appbart.dart';
import 'package:mobilidade_urbana_app/features/home/presentation/widgets/nearby_vehicles.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            THomeAppBar(isDark: isDark),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: TSizes.xs,
                vertical: TSizes.sm,
              ),
              child: Column(
                children: [
                  TSearchContainer(
                    isDark: isDark,
                    placeholder: 'Para onde você quer ir?',
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const SearchScreen(),
                        transitionDuration: const Duration(milliseconds: 350),
                        reverseTransitionDuration:
                            const Duration(milliseconds: 300),
                        transitionsBuilder: (_, animation, __, child) =>
                            FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: TSizes.spaceBtwSections),
                  // NearbyVehicles(),
                  SizedBox(height: TSizes.spaceBtwSections),
                  FavoritesSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
