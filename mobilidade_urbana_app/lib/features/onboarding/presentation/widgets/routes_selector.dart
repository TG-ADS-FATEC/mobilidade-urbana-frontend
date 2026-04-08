import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/features/onboarding/controllers/onboarding_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class OnboardingRouteSelector extends StatelessWidget {
  const OnboardingRouteSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final isDark = THelperFunctions.isDarkMode(context);

    final routeOptions = [
      (
      label: 'Mais rápida',
      icon: Icons.flash_on_outlined,
      ),
      (
      label: 'Menos trocas',
      icon: Icons.swap_horiz,
      ),
      (
      label: 'Caminhar menos',
      icon: Icons.directions_walk_outlined,
      ),
    ];

    return Obx(
          () => Column(
        children: routeOptions.map((option) {
          final selected =
              controller.selectedRoutePreference.value == option.label;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: selected
                  ? isDark ? TColors.darkBackground : TColors.lightGrey
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: RadioListTile<String>(
              value: option.label,
              groupValue: controller.selectedRoutePreference.value,
              onChanged: (value) {
                if (value != null) {
                  controller.updateRoutePreference(value);
                }
              },
              secondary: Icon(option.icon),
              title: Text(option.label),
              activeColor: TColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}