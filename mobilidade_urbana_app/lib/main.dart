import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/core/di/service_locator.dart';
import 'package:mobilidade_urbana_app/core/services/auth_service.dart';
import 'package:mobilidade_urbana_app/core/services/onboarding_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();
  // await HiveInit.init();
  await AuthService.authenticate();
  final isOnboardingComplete = await OnboardingService.isComplete();

  runApp(
    ProviderScope(
      child: App(isOnboardingComplete: isOnboardingComplete),
    ),
  );
}
