import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/features/home/presentation/widgets/home_appbart.dart';
import 'package:mobilidade_urbana_app/features/home/presentation/widgets/nearby_vehicles.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            THomeAppBar(isDark: isDark),
            Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: TSizes.xs, vertical: TSizes.sm),
                child: Column(
                  children: [
                    NearbyVehicles(),
                    SizedBox(height: 40),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}




