import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mobilidade_urbana_app/core/bindings/onboading_binding.dart';
import 'package:mobilidade_urbana_app/core/router/app_router.dart';
import 'package:mobilidade_urbana_app/features/onboarding/data/data_sources/onboarding_local_datasource.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:mobilidade_urbana_app/navigation_menu.dart';
import 'package:mobilidade_urbana_app/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingFinished = OnboardingLocalDatasource().isCompleted; // ✅

    final double scale = 1.0;

    return GetMaterialApp(
      title: 'Mobilidade Urbana',

      initialBinding: OnboadingBinding(),
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme(scale),
      darkTheme: TAppTheme.darkTheme(scale),
      home: onboardingFinished ? const NavigationMenu() : const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.routes,
    );
  }
}