import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilidade_urbana_app/navigation_menu.dart';

class OnboardingSuccessScreen extends StatefulWidget {
  const OnboardingSuccessScreen({super.key});

  @override
  State<OnboardingSuccessScreen> createState() =>
      _OnboardingSuccessScreenState();
}

class _OnboardingSuccessScreenState extends State<OnboardingSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Get.offAll(() => const NavigationMenu());
      }
    });
  }

  void _onLottieLoaded(LottieComposition composition) {
    _controller
      ..duration = composition.duration
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: Lottie.network(
            'https://lottie.host/13acd1b3-863a-444b-981c-e0db041f12c4/gO8GvwCpJD.json',
            controller: _controller,
            width: 320,
            height: 320,
            fit: BoxFit.contain,
            onLoaded: _onLottieLoaded,
            errorBuilder: (context, error, stackTrace) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Get.offAll(() => const HomeScreen());
              });

              return Icon(
                Icons.check_circle_rounded,
                size: 80,
                color: cs.primary,
              );
            },
          ),
        ),
      ),
    );
  }
}