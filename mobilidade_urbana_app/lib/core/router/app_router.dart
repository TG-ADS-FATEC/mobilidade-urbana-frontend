import 'package:go_router/go_router.dart';
import 'package:mobilidade_urbana_app/features/home/presentation/screens/home_screen.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/screens/success_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:mobilidade_urbana_app/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:mobilidade_urbana_app/navigation_menu.dart';

class AppRouter {
  static GoRouter router(bool isOnboardingComplete) => GoRouter(
        initialLocation: isOnboardingComplete ? '/home' : '/welcome',
        routes: [
          GoRoute(
            path: '/welcome',
            builder: (context, state) => const WelcomeScreen(),
          ),
          GoRoute(
            path: '/onboarding',
            builder: (context, state) => const OnboardingScreen(),
          ),
          GoRoute(
            path: '/onboarding-success',
            builder: (context, state) => const OnboardingSuccessScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) => const NavigationMenu(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/profile/edit-profile',
            builder: (context, state) => const EditProfileScreen(),
          ),
        ],
      );
}
