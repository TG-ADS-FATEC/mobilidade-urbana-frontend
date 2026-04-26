import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences.entity.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/controllers/preferences_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class ProfileRouteSelector extends StatelessWidget {
  const ProfileRouteSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PreferencesController>();
    final isDark = THelperFunctions.isDarkMode(context);

    final routeOptions = [
      (
      label: 'Mais rápida',
      icon: Icons.flash_on_outlined,
      value: RoutePreference.fastest,
      ),
      (
      label: 'Menos trocas',
      icon: Icons.swap_horiz,
      value: RoutePreference.shortest,
      ),
      (
      label: 'Caminhar menos',
      icon: Icons.directions_walk_outlined,
      value: RoutePreference.leastWalking,
      ),
    ];

    return Obx(() {
      final current = controller.preferences.value;
      if (current == null) return const SizedBox.shrink();

      return RadioGroup<RoutePreference>(
        groupValue: current.routePreference,
        onChanged: (value) {
          if (value == null) return;
          controller.updatePreferences(
            current.copyWith(routePreference: value),
          );
        },
        child: Column(
          children: routeOptions.map((option) {
            final selected = current.routePreference == option.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: selected
                    ? isDark
                    ? TColors.darkBackground
                    : TColors.lightGrey
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: RadioListTile<RoutePreference>(
                value: option.value,
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
    });
  }
}