import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/controller/splashcontroller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


final SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image:AssetImage('assets/images/splashbackground.png',),fit: BoxFit.cover
              )
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 150),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Image.asset('assets/images/logo.png',height:260,),
                      Text("Grocery Hub",style: TextStyle(color: Colors.green.shade700,fontWeight: FontWeight.bold,fontSize: 30,),),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: CircularProgressIndicator(
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
