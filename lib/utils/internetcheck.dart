// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:get/get.dart';
// import 'package:internet_speed_test/internet_speed_test.dart';
// class InternetChecker {
//   static final InternetChecker _instance = InternetChecker._internal();
//   factory InternetChecker() => _instance;
//
//   late StreamSubscription<ConnectivityResult> _connectivitySubscription;
//   final InternetSpeedTest _internetSpeedTest = InternetSpeedTest();
//   bool isConnected = true;
//   bool isSlowNetwork = false;
//
//   InternetChecker._internal();
//
//   /// Initialize the internet checker
//   void initialize() {
//     _checkInitialConnectivity();
//     _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//       if (result == ConnectivityResult.none) {
//         _showNoInternetPopup();
//         isConnected = false;
//       } else {
//         if (!isConnected) {
//           _hidePopup();
//         }
//         isConnected = true;
//         _checkNetworkSpeed();
//       }
//     });
//   }
//
//   /// Check the initial connectivity status when the app launches
//   Future<void> _checkInitialConnectivity() async {
//     ConnectivityResult result = await Connectivity().checkConnectivity();
//     if (result == ConnectivityResult.none) {
//       _showNoInternetPopup();
//       isConnected = false;
//     } else {
//       isConnected = true;
//       _checkNetworkSpeed();
//     }
//   }
//
//   /// Check network speed and show a popup if the speed is slow
//   void _checkNetworkSpeed() {
//     _internetSpeedTest.startDownloadTesting(
//       onProgress: (percent, transferRate, unit) {
//         double speedInKbps = unit == 'kbps' ? transferRate : transferRate * 1000;
//         print("Download speed: $speedInKbps kbps");
//
//         if (speedInKbps < 500) { // Change threshold if needed
//           if (!isSlowNetwork) {
//             _showSlowNetworkPopup();
//           }
//           isSlowNetwork = true;
//         } else {
//           _hidePopup();
//           isSlowNetwork = false;
//         }
//       },
//       onDone: (transferRate, unit) {
//         print('Download Test Done. Final Speed: $transferRate $unit');
//       },
//       onError: (errorMessage, speedTestError) {
//         print('Speed Test Error: $errorMessage');
//       },
//     );
//   }
//
//   /// Show popup for no internet
//   void _showNoInternetPopup() {
//     Get.snackbar(
//       'No Internet Connection',
//       'Please check your internet connection.',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Get.theme.primaryColor,
//       colorText: Get.theme.colorScheme.onPrimary,
//       duration: const Duration(seconds: 5),
//     );
//   }
//
//   /// Show popup for slow network
//   void _showSlowNetworkPopup() {
//     Get.snackbar(
//       'Slow Network Detected',
//       'Your internet connection is slow. Please be patient.',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Get.theme.primaryColor,
//       colorText: Get.theme.colorScheme.onPrimary,
//       duration: const Duration(seconds: 5),
//     );
//   }
//
//   /// Hide popups
//   void _hidePopup() {
//     Get.closeAllSnackbars();
//   }
//
//   /// Dispose of the connectivity subscription
//   void dispose() {
//     _connectivitySubscription.cancel();
//   }
// }
