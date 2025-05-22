import 'package:mybudget/core/utils/constants.dart';
import 'package:mybudget/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:mybudget/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  @override
  Future<List<OnboardingPage>> getOnboardingData() async {
    return [
      OnboardingPage(
        title: 'Welcome to MyBudget',
        description: 'Manage your finances with the 6 Jars method.',
        image: 'assets/images/onboarding1.png',
      ),
      OnboardingPage(
        title: 'Track Your Jars',
        description: 'Organize your money into 6 jars for better control.',
        image: 'assets/images/onboarding2.png',
      ),
      OnboardingPage(
        title: 'Plan and Save',
        description: 'Set budgets and generate reports to achieve your goals.',
        image: 'assets/images/onboarding3.png',
      ),
    ];
  }

  @override
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(AppConstants.onboardingKey) ?? false);
  }

  @override
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingKey, true);
  }
}
