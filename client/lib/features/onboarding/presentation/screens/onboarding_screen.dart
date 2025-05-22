import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mybudget/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);

    return Scaffold(
      body: IntroductionScreen(
        pages:
            provider.onboardingData.map((item) {
              return PageViewModel(
                title: item.title,
                body: item.description,
                image: Center(child: Image.asset(item.image, height: 250)),
                decoration: const PageDecoration(
                  titleTextStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  bodyTextStyle: TextStyle(fontSize: 16),
                  pageColor: Colors.white,
                  imagePadding: EdgeInsets.only(top: 40),
                ),
              );
            }).toList(),
        onDone: () {
          provider.completeOnboarding();
          Navigator.pushReplacementNamed(context, '/auth_check');
        },
        onSkip: () {
          provider.completeOnboarding();
          Navigator.pushReplacementNamed(context, '/auth_check');
        },
        showSkipButton: true,
        skip: const Text('Bỏ qua'),
        next: const Text(
          'Tiếp tục',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        done: const Text(
          'Bắt đầu',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size(10, 10),
          activeSize: const Size(22, 10),
          activeColor: Theme.of(context).primaryColor,
          color: Colors.grey,
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}
