import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/features/onboarding/controllers/onboarding_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';
import 'walking_duration_bottom_sheet.dart';

class OnboardingWalkingOptions extends StatelessWidget {
  const OnboardingWalkingOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = OnBoardingController.instance;

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TSizes.spaceBtwSections),
        _WalkingPaceSwitch(
          isDark: isDark,
          value: controller.slowWalkingPace.value,
          onChanged: controller.updateSlowWalkingPace,
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
        _WalkingDurationSection(
          duration: controller.walkingDuration.value,
        ),
      ],
    ));
  }
}

class _WalkingPaceSwitch extends StatelessWidget {
  final bool isDark;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _WalkingPaceSwitch({
    required this.isDark,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Ritmo de caminhada lento',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: Colors.white,
          activeTrackColor: TColors.primary,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: isDark ? Colors.black38 : Colors.grey.shade300,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _WalkingDurationSection extends StatelessWidget {
  final double duration;

  const _WalkingDurationSection({required this.duration});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duração da caminhada',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Text(
          'Define o máximo de minutos para cada seção de caminhada da sua viagem',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () => WalkingDurationBottomSheet.show(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : Colors.black,
                side: BorderSide(color: isDark ? Colors.white : Colors.black),
              ),
              icon: const Icon(Icons.directions_walk_outlined, size: 18),
              label: const Text('Definir duração'),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
              child: Text(
                duration >= 60
                    ? 'Padrão (sem limite)'
                    : '${duration.toInt()} min',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}