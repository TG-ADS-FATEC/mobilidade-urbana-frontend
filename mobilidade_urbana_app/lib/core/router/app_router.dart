// import 'package:go_router/go_router.dart';
// import 'package:mobilidade_urbana_app/features/onboarding/screens/onboarding.dart';
//
// final GoRouter appRouter = GoRouter(
//     initialLocation: '/',
//     routes: [
//       GoRoute(
//           path: '/onboarding',
//           builder: (context, state) => const OnboardingScreen(),
//       )
//     ]
// );

import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/core/bindings/onboading_binding.dart';
import 'package:mobilidade_urbana_app/core/bindings/preferences_binding.dart';
import 'package:mobilidade_urbana_app/core/bindings/profile_binding.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:mobilidade_urbana_app/features/welcome/presentation/screens/welcome_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/welcome',
      page: () => WelcomeScreen(),
    ),
    GetPage(
      name: '/onboarding',
      page: () => OnboardingScreen(),
      binding: OnboadingBinding(),
    ),
    GetPage(
      name: '/profile',
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/profile/edit-profile',
      page: () => const EditProfileScreen(),
      bindings: [ProfileBinding(), PreferencesBinding()],
    ),
  ];
}