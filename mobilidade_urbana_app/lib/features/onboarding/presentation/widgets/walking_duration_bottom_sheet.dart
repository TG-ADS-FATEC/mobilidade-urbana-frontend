import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class WalkingDurationBottomSheet {
  static void show(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? TColors.darkBackground : TColors.light,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _WalkingDurationContent(),
    );
  }
}

class _WalkingDurationContent extends StatelessWidget {
  const _WalkingDurationContent();

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final isDark = THelperFunctions.isDarkMode(context);

    return Obx(
          () => Container(
        color: isDark ? TColors.darkBackground : TColors.light,
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Duração máxima da caminhada',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                '${controller.walkingDuration.value.toInt()} minutos',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Slider(
                value: controller.walkingDuration.value,
                min: 5,
                max: 60,
                divisions: 11,
                activeColor: TColors.primary,
                inactiveColor: isDark ? Colors.white24 : Colors.grey.shade300,
                onChanged: controller.updateWalkingDuration,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                  ),
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}