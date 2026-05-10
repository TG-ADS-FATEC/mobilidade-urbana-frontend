import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences_entity.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/controllers/preferences_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class ProfileRouteSelector extends ConsumerWidget {
  const ProfileRouteSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(preferencesControllerProvider);
    final notifier = ref.read(preferencesControllerProvider.notifier);
    final isDark = THelperFunctions.isDarkMode(context);

    final current = state.preferences;
    if (current == null) return const SizedBox.shrink();

    final routeOptions = [
      (label: 'Mais rápida', icon: Icons.flash_on_outlined, value: RoutePreference.fastest),
      (label: 'Menos trocas', icon: Icons.swap_horiz, value: RoutePreference.shortest),
      (label: 'Caminhar menos', icon: Icons.directions_walk_outlined, value: RoutePreference.leastWalking),
    ];

    return RadioGroup<RoutePreference>(
      groupValue: current.routePreference,
      onChanged: (value) {
        if (value != null) {
          notifier.updatePreferences(current.copyWith(routePreference: value));
        }
      },
      child: Column(
        children: routeOptions.map((option) {
          final selected = current.routePreference == option.value;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: selected
                  ? (isDark ? TColors.darkBackground : TColors.lightGrey)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? TColors.primary
                    : Colors.grey.withValues(alpha: 0.2),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: RadioListTile<RoutePreference>(
              value: option.value,
              secondary: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: selected ? 1.1 : 1,
                child: Icon(
                  option.icon,
                  color: selected ? TColors.primary : null,
                ),
              ),
              title: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected
                      ? TColors.primary
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
                child: Text(option.label),
              ),
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
