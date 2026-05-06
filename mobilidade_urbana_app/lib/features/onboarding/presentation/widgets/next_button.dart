import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/device/device_utility.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class OnBoardingNextButton extends ConsumerWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Positioned(
      right: TSizes.defaultSpace,
      bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () =>
            ref.read(onboardingControllerProvider.notifier).nextPage(),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          alignment: Alignment.center,
          minimumSize: const Size(72, 72),
          foregroundColor: isDark ? TColors.light : TColors.dark,
        ),
        child: const Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}
