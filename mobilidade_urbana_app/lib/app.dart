import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/core/router/app_router.dart';
import 'package:mobilidade_urbana_app/utils/theme/theme.dart';

class App extends StatelessWidget {
  final bool isOnboardingComplete;
  final double scaleFactor = 1.0;

  const App({super.key, required this.isOnboardingComplete});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mobilidade Urbana',
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme(scaleFactor),
      darkTheme: TAppTheme.darkTheme(scaleFactor),
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router(isOnboardingComplete),
    );
  }
}
