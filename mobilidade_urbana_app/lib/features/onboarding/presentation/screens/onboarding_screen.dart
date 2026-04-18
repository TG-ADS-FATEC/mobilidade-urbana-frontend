// presentation/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/widgets/dot_navigation.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/widgets/next_button.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/widgets/page_layout1.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/widgets/previous_button.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/widgets/routes_selector.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/widgets/transport_selector.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/widgets/walking_options.dart';
import 'package:mobilidade_urbana_app/utils/constants/onboarding_texts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance; 

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPageLayout1(
                title: OnboardingTexts.OnboardingTitle1,
                description: OnboardingTexts.OnboardingDescription1,
                child: OnboardingTransportSelector(),
              ),
              OnBoardingPageLayout1(
                title: OnboardingTexts.OnboardingTitle2,
                description: '',
                child: OnboardingRouteSelector(),
              ),
              OnBoardingPageLayout1(
                title: OnboardingTexts.OnboardingTitle3,
                description: OnboardingTexts.OnboardingDescription3,
                child: OnboardingWalkingOptions(),
              ),
            ],
          ),
          const OnBoardingPrevious(),
          const OnBoardingDotNavigation(),
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}