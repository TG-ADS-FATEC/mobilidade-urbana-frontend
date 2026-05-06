import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/device/device_utility.dart';

class OnBoardingSkip extends ConsumerWidget {
  const OnBoardingSkip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      left: TSizes.defaultSpace,
      child: TextButton(
        onPressed: () =>
            ref.read(onboardingControllerProvider.notifier).skipPage(),
        child: const Text('Pular'),
      ),
    );
  }
}
