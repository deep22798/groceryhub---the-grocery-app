import 'package:get/get.dart';
import 'package:grocery/controller/binding/splashbinding.dart';
import 'package:grocery/controller/splashcontroller.dart';
import 'package:grocery/view/splash.dart';
import 'package:grocery/view/Onboarding/onboarding.dart';
import 'package:grocery/view/dashboard/dashboard.dart';

class Routes {
  static String splash = '/splash';
  static String onboarding = '/onboarding';
  static String dashboard = '/dashboard';
}

final getPages = [
  GetPage(
    name: Routes.splash,
    page: () => const SplashScreen(),
    binding: SplashBinding(),
  ),
  GetPage(
    name: Routes.onboarding,
    page: () => OnboardingScreen(),
  ),
  GetPage(
    name: Routes.dashboard,
    page: () => Dashboard(),
  ),
];
