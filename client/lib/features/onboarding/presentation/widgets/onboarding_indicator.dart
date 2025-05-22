import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mybudget/features/onboarding/presentation/providers/onboarding_provider.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        provider.onboardingData.length,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                provider.currentPage == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
          ),
        ),
      ),
    );
  }
}
