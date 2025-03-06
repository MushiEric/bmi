import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../screens/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final GetStorage _storage = GetStorage();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = (index == 2); // Check if on the last page
              });
            },
            children: [
              _buildPage(
                "Track Your BMI",
                "Monitor your health easily.",
                "assets/animation1.json",
              ),
              _buildPage(
                "View History",
                "Keep track of your past BMI records.",
                "assets/animation2.json",
              ),
              _buildPage(
                "Get Personalized Tips",
                "Stay fit with health suggestions.",
                "assets/animation3.json",
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(dotHeight: 10, dotWidth: 10),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _storage.write("seenOnboarding", true); // Save flag
                    Get.off(HomeScreen()); // Go to home
                  },
                  child: Text(isLastPage ? "Get Started" : "Next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String title, String description, String asset) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(description, textAlign: TextAlign.center),
        SizedBox(height: 20),
        Image.asset(asset, height: 200),
      ],
    );
  }
}
