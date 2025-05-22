import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:mybudget/features/auth/presentation/screens/login_screen.dart';
import 'package:mybudget/features/onboarding/presentation/providers/onboarding_provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context, listen: false);

    // Load onboarding data when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadOnboardingData();
    });

    return Scaffold(
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, _) {
          if (provider.pages.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return IntroductionScreen(
            pages:
                provider.pages.map((page) {
                  return PageViewModel(
                    title: page.title,
                    body: page.description,
                    image: Image.asset(page.image, height: 300),
                    decoration: const PageDecoration(
                      titleTextStyle: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      bodyTextStyle: TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
            onDone: () async {
              await provider.complete();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            showSkipButton: true,
            skip: const Text('Skip'),
            next: const Icon(Icons.arrow_forward),
            done: const Text(
              'Get Started',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            dotsDecorator: const DotsDecorator(
              size: Size(10, 10),
              activeSize: Size(22, 10),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
            ),
          );
        },
      ),
    );
  }
}
