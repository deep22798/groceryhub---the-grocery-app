import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:grocery/utils/routes.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int currentIndex = 0;

  List<Widget> _buildPages() {
    return [
      _buildPage(
        title: "Let's Explore",
        description: "Stay connected and manage your school life effortlessly with SMPS Educare",
        imageAsset: "assets/images/onboarding/onboarding1.png",
      ),
      _buildPage(
        title: "Get Items in your cart",
        description: "Effortlessly browse products and add them to your cart.",
        imageAsset: "assets/images/onboarding/onboarding2.png",
      ),
      _buildPage(
        title: "Place Order",
        description: "Get your order completed quickly and hassle-free.",
        imageAsset: "assets/images/onboarding/onboarding3.png",
      ),
    ];
  }

  Widget _buildPage({String? title, String? description, String? imageAsset}) {
    return Container(
      color: Colors.blue.shade50,
      child: Stack(
        children: [
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Container(
          //     height: 160,
          //     width: 200,
          //     child: Padding(
          //       padding: const EdgeInsets.only(top: 30, bottom: 20),
          //       child: Image.asset('assets/images/logo.png'),
          //     ),
          //     decoration: BoxDecoration(
          //       color: Colors.pink.shade700,
          //       borderRadius: BorderRadius.only(
          //           bottomRight: Radius.circular(100),
          //           bottomLeft: Radius.circular(100)),
          //     ),
          //   ),
          // ),

          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60, left: 60, right: 60),
              child:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentIndex >0?InkWell(
                    onTap: _onPrevious,
                    child: Card(
                      color:Colors.green,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10000)
                        ),
                        height: 60,width: 60,child:Center(
                          child: Icon(Icons.arrow_back_ios,
                            color: Colors.white,
                          )
                      ) ,
                      ),
                    ),
                  ):Text(''),
                  InkWell(
                    onTap: _onNext,
                    child: Card(
                      color:currentIndex == 2 ?Colors.orange: Colors.green,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10000)
                        ),
                        height: 60,width: 60,child:Center(
                          child: Icon(currentIndex == 2 ? Icons.dashboard:Icons.arrow_forward_ios,
                            color: Colors.white,
                          )
                      ) ,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(imageAsset!),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    title!,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: RichText(
                    text: TextSpan(
                      text: description,
                      style: TextStyle(color: Colors.black),
                    ),
                    maxLines: 10,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onNext() async {
    if (currentIndex < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isonboard', true); // Mark onboarding as completed
      Get.offNamed(Routes.dashboard); // Navigate to Dashboard
    }
  }



  void _onPrevious() async {
    if (currentIndex > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isonboard', true); // Mark onboarding as completed

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: _buildPages(),
      ),
      backgroundColor: Colors.blue.shade50,
    );
  }
}
