import 'package:mybudget/core/utils/constants.dart';
import 'package:mybudget/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:mybudget/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // Để sử dụng debugPrint

class OnboardingRepositoryImpl implements OnboardingRepository {
  @override
  Future<List<OnboardingPage>> getOnboardingData() async {
    try {
      debugPrint('OnboardingRepository: Loading onboarding data...');
      final pages = [
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
          description:
              'Set budgets and generate reports to achieve your goals.',
          image: 'assets/images/onboarding3.png',
        ),
      ];
      debugPrint('OnboardingRepository: Loaded ${pages.length} pages');
      return pages;
    } catch (e) {
      debugPrint('OnboardingRepository: Error loading onboarding data: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  @override
  Future<bool> isFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding =
          prefs.getBool(AppConstants.onboardingKey) ?? false;
      debugPrint('OnboardingRepository: isFirstLaunch = ${!hasSeenOnboarding}');
      return !hasSeenOnboarding;
    } catch (e) {
      debugPrint('OnboardingRepository: Error checking isFirstLaunch: $e');
      return true; // Mặc định là lần đầu nếu có lỗi
    }
  }

  @override
  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.onboardingKey, true);
      debugPrint('OnboardingRepository: Onboarding completed');
    } catch (e) {
      debugPrint('OnboardingRepository: Error completing onboarding: $e');
    }
  }

  Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.onboardingKey);
      debugPrint('OnboardingRepository: Onboarding status reset');
    } catch (e) {
      debugPrint('OnboardingRepository: Error resetting onboarding: $e');
    }
  }
}
