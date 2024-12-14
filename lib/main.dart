import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocery/utils/internetcheck.dart';
import 'package:grocery/utils/routes.dart';

// import 'package:connectivity_plus/connectivity_plus.dart';
void main() {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarIconBrightness: Brightness.dark));
  runApp(MyApp());
  // InternetChecker().initialize();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splash,  // Start with the splash screen
      getPages: getPages,  // Define all routes
    );
  }
}
