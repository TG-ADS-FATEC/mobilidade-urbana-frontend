import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/core/bindings/onboading_binding.dart';
import 'package:mobilidade_urbana_app/core/bindings/preferences_binding.dart';
import 'package:mobilidade_urbana_app/core/bindings/profile_binding.dart';
import 'package:mobilidade_urbana_app/features/home/presentation/screens/home_screen.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/screens/success_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:mobilidade_urbana_app/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:mobilidade_urbana_app/navigation_menu.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/welcome',
      page: () => WelcomeScreen(),
    ),
    GetPage(
      name: '/onboarding',
      page: () => OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: '/onboarding-success',
      page: () => OnboardingSuccessScreen(),
    ),
    GetPage(
      name: '/home',
      page: () =>  NavigationMenu(),
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