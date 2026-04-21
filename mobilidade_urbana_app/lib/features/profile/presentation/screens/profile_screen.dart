import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/profile_appbar.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/profile_info.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/profile_shortcuts.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/profile_statistics.dart';


import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TProfileAppBar(isDark: isDark),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: TSizes.xs, vertical: TSizes.sm),
              child: Column(
                children: [
                  ProfileInfo(),
                  SizedBox(height: 40),
                  ProfileStats(traveledKm: 24, totalPoints: 240, hikingKm: 8, tripsMade: 8),
                  SizedBox(height: TSizes.spaceBtwSections),
                  ProfileShortcuts()
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}




