import 'package:get/get.dart';
import 'package:grocery/utils/routes.dart';
import 'package:grocery/view/dashboard/dashboard.dart';
import 'package:grocery/view/Onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var isOnboarded = prefs.getBool('isonboard') ?? false;

      if (isOnboarded) {
        Get.offNamed(Routes.dashboard); // Navigate to the Dashboard
      } else {
        Get.offNamed(Routes.onboarding); // Navigate to the Onboarding screen
      }
    });
  }
}
