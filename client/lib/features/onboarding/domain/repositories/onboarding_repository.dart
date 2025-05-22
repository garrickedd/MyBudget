import 'package:mybudget/features/onboarding/domain/entities/onboarding_page.dart';

abstract class OnboardingRepository {
  Future<List<OnboardingPage>> getOnboardingData();
  Future<bool> isFirstLaunch();
  Future<void> completeOnboarding();
}
