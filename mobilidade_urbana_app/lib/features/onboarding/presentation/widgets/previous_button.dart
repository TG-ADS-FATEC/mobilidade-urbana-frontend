import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/device/device_utility.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class OnBoardingPrevious extends StatelessWidget {
  const OnBoardingPrevious({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      left: TSizes.defaultSpace - 16,
      child: TextButton.icon(
        onPressed: () => OnBoardingController.instance.previousPage(),
        icon: Icon(
          Icons.arrow_back,
          color: isDark ? TColors.light : TColors.dark,
        ),
        label: Text(
          'Voltar',
          style: TextStyle(
            color: isDark ? TColors.light : TColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: TSizes.sm,
            vertical: TSizes.xs,
          ),
        ),
      ),
    );
  }
}
