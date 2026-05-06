import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/widgets/dot_navigation.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/widgets/next_button.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/widgets/page_layout1.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/widgets/previous_button.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/widgets/routes_selector.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/widgets/transport_selector.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/widgets/walking_options.dart';
import 'package:mobilidade_urbana_app/utils/constants/onboarding_texts.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(onboardingControllerProvider.notifier);

    ref.listen(
      onboardingControllerProvider.select((s) => s.navigation),
      (prev, next) {
        if (next == OnboardingNavigation.none) return;
        if (next == OnboardingNavigation.back) {
          context.pop();
        } else if (next == OnboardingNavigation.success) {
          context.go('/onboarding-success');
        }
        notifier.clearNavigation();
      },
    );

    ref.listen(
      onboardingControllerProvider.select((s) => s.errorMessage),
      (prev, next) {
        if (next.isEmpty || next == prev) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next),
            backgroundColor: Colors.red,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );

    ref.listen(
      onboardingControllerProvider.select((s) => s.isShowingValidationSnackbar),
      (prev, next) {
        if (!next || prev == true) return;
        final state = ref.read(onboardingControllerProvider);
        final messages = {
          0: 'Selecione pelo menos um meio de transporte.',
          1: 'Selecione uma preferência de rota.',
        };
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              messages[state.currentPageIndex] ??
                  'Preencha as informações antes de continuar.',
            ),
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: notifier.pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: notifier.updatePageIndicator,
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
