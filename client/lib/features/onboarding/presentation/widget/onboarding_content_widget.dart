// widget to show content from onboarding
import 'package:flutter/material.dart';
import 'package:my_budget/features/onboarding/domain/entities/onboarding_entitiy.dart';

class OnboardingContentWidget extends StatelessWidget {
  final OnboardingEntitiy content;

  const OnboardingContentWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(content.imageUrl, height: 280, fit: BoxFit.contain),
          const SizedBox(height: 32),
          Text(
            content.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            content.description,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
