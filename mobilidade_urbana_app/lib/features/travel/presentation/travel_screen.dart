import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/core/widgets/search_container.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/home/presentation/screens/search_screen.dart';
import 'package:mobilidade_urbana_app/features/home/presentation/widgets/favorites_section.dart';
import 'package:mobilidade_urbana_app/features/home/presentation/widgets/home_appbart.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class TravelScreen extends StatelessWidget {
  final FavoriteEntity? destination;

  const TravelScreen({super.key, this.destination});

  @override
  Widget build(BuildContext context) {
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
                    placeholder: 'Origem',
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                  TSearchContainer(
                    isDark: isDark,
                    placeholder: 'Destino',
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