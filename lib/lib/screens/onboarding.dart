import 'package:coiffinder/controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Stack(children: [
        ///horizontal scrollable pages
        PageView(
          controller: controller.pageController,
          onPageChanged: controller.updatePageIndicator,
          children: [
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height *
                        0.6, // 60% of the screen height
                    child: FractionallySizedBox(
                        widthFactor: 1, // 100% of the screen width
                        child: Image.asset(
                          'assets/images/onboarding_images/Hairdresser (1).gif',
                          fit: BoxFit.cover,
                        )),
                  ),
                  const Text(
                    'Choose a service',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 27.0),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    ' Explore a world of beauty and wellness with Coiffinder, where convenience meets expertise, ensuring you look and feel your best.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 13.0),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height *
                        0.6, // 60% of the screen height
                    child: FractionallySizedBox(
                        widthFactor: 1, // 100% of the screen width
                        child: Image.asset(
                          'assets/images/onboarding_images/hairdresser team.gif',
                          fit: BoxFit.cover,
                        )),
                  ),
                  const Text(
                    'Pick a stylist',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 27.0),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '  You are given the autonomy to curate your personal grooming experience with someone who aligns perfectly with your preferences.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 13.0),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height *
                        0.6, // 60% of the screen height
                    child: FractionallySizedBox(
                        widthFactor: 1, // 100% of the screen width
                        child: Image.asset(
                          'assets/images/onboarding_images/Time management.gif',
                          fit: BoxFit.cover,
                        )),
                  ),
                  const Text(
                    'Book an appointment',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 27.0),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    ' book a time that is most convenient for you. We value your time, and we want to ensure that your schedule aligns seamlessly with our services.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 13.0),
                  )
                ],
              ),
            )
          ],
        ),
        Positioned(
            top: 35,
            right: -5,
            child: TextButton(
                onPressed: ()=>OnBoardingController.instance.skipPage(), 
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.pink),
                ))),
        Positioned(

            
            bottom: 90,
            left: 20,
            child: SmoothPageIndicator(
                controller: controller.pageController,
                onDotClicked: controller.dotNavigationClick,
                count: 3,
                effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.pink, dotHeight: 6))),
                    
        Positioned(
            
            bottom: 70,
            right: 20,
            child: ElevatedButton(
                onPressed: () =>OnBoardingController.instance.nextPage(),
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    surfaceTintColor: Colors.white,
                    backgroundColor: Colors.pink),
                child: const Icon(Iconsax.arrow_right_3, color: Colors.white)))
      ]),
    );
  }
}
