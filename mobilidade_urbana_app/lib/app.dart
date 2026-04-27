import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/core/router/app_router.dart';
import 'package:mobilidade_urbana_app/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:mobilidade_urbana_app/navigation_menu.dart';
import 'package:mobilidade_urbana_app/utils/theme/theme.dart';

class App extends StatelessWidget {
  final bool isOnboardingComplete;
  final double scaleFactor = 1.0;

  const App({super.key, required this.isOnboardingComplete});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mobilidade Urbana',
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme(scaleFactor),
      darkTheme: TAppTheme.darkTheme(scaleFactor),
      initialRoute: isOnboardingComplete ? '/home' : '/welcome',
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.routes,
    );
  }
}