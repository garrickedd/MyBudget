import 'package:my_budget/features/onboarding/data/models/onboarding_model.dart';

abstract class OnboardingLocalDataSource {
  List<OnboardingModel> getOnboardingContent();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  @override
  List<OnboardingModel> getOnboardingContent() {
    return [
      OnboardingModel(
        title: 'Take Control of Your Finances',
        description: 'Track your income and expeneses effortlessly.',
        imageUrl: 'assets/onboarding/1.png',
      ),
      OnboardingModel(
        title: 'Set Financial Goals',
        description: 'Plan for your future with smart budgeting.',
        imageUrl: 'assets/onboarding/2.png',
      ),
      OnboardingModel(
        title: 'Stay on Track',
        description: 'Get insights to make informed decisions.',
        imageUrl: 'assets/onboarding/3.png',
      ),
    ];
  }
}
