import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart'; // Để sử dụng debugPrint
import 'package:mybudget/features/auth/presentation/screens/login_screen.dart';
import 'package:mybudget/features/onboarding/presentation/providers/onboarding_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    // Load data immediately
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    provider.loadOnboardingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            debugPrint('OnboardingScreen: Showing loading indicator');
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            debugPrint('OnboardingScreen: Error: ${provider.errorMessage}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.loadOnboardingData();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (provider.pages.isEmpty) {
            debugPrint('OnboardingScreen: Pages are empty');
            return const Center(child: Text('No onboarding data available'));
          }
          debugPrint(
            'OnboardingScreen: Displaying ${provider.pages.length} pages',
          );
          return IntroductionScreen(
            pages:
                provider.pages.map((page) {
                  return PageViewModel(
                    title: page.title,
                    body: page.description,
                    image: Image.asset(
                      page.image,
                      height: 300,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint(
                          'OnboardingScreen: Error loading image ${page.image}: $error',
                        );
                        return const Icon(
                          Icons.error,
                          size: 100,
                          color: Colors.red,
                        );
                      },
                    ),
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
              debugPrint('OnboardingScreen: Navigating to LoginScreen');
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
