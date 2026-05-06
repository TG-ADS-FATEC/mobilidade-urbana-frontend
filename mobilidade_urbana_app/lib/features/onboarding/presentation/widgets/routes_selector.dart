import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences.entity.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class OnboardingRouteSelector extends ConsumerWidget {
  const OnboardingRouteSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);
    final isDark = THelperFunctions.isDarkMode(context);

    final routeOptions = [
      (label: 'Mais rápida', icon: Icons.flash_on_outlined, value: RoutePreference.fastest),
      (label: 'Menos trocas', icon: Icons.swap_horiz, value: RoutePreference.shortest),
      (label: 'Caminhar menos', icon: Icons.directions_walk_outlined, value: RoutePreference.leastWalking),
    ];

    return RadioGroup<RoutePreference>(
      groupValue: state.selectedRoutePreference,
      onChanged: (value) {
        if (value != null) notifier.updateRoutePreference(value);
      },
      child: Column(
        children: routeOptions.map((option) {
          final selected = state.selectedRoutePreference == option.value;

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
              title: Text(option.label),
              secondary: Icon(option.icon),
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
