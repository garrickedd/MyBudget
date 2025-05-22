import 'package:mybudget/features/onboarding/data/models/onboarding_model.dart';

abstract class OnboardingRepository {
  Future<bool> isFirstLaunch();
  Future<void> completeOnboarding();
  List<OnboardingModel> getOnboardingData();
}
