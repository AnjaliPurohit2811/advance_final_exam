import 'package:advance_final_exam/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 380, left: 120),
            child: GestureDetector(
              onTap: () {
                Get.to(HomeScreen());
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('asset/img/logo.jpg'))
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
