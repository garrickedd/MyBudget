import 'package:flutter/foundation.dart';
import 'package:mybudget/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:mybudget/features/onboarding/domain/usecases/check_onboarding_status.dart';
import 'package:mybudget/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:mybudget/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingProvider extends ChangeNotifier {
  final CheckOnboardingStatus checkOnboardingStatus;
  final CompleteOnboarding completeOnboarding;
  final OnboardingRepository repository;
  bool _isFirstLaunch = true;
  List<OnboardingPage> _pages = [];
  bool _isLoading = false;
  String? _errorMessage;

  OnboardingProvider({
    required this.checkOnboardingStatus,
    required this.completeOnboarding,
    required this.repository,
  });

  bool get isFirstLaunch => _isFirstLaunch;
  List<OnboardingPage> get pages => _pages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> checkStatus() async {
    try {
      debugPrint('OnboardingProvider: Checking onboarding status...');
      _isFirstLaunch = await checkOnboardingStatus();
      debugPrint('OnboardingProvider: isFirstLaunch = $_isFirstLaunch');
      notifyListeners();
      return _isFirstLaunch;
    } catch (e) {
      debugPrint('OnboardingProvider: Error checking status: $e');
      _isFirstLaunch = true; // Mặc định là lần đầu nếu có lỗi
      notifyListeners();
      return _isFirstLaunch;
    }
  }

  Future<void> complete() async {
    try {
      await completeOnboarding();
      _isFirstLaunch = false;
      debugPrint('OnboardingProvider: Onboarding completed');
      notifyListeners();
    } catch (e) {
      debugPrint('OnboardingProvider: Error completing onboarding: $e');
    }
  }

  Future<void> loadOnboardingData() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      debugPrint('OnboardingProvider: Loading onboarding data...');

      _pages = await repository.getOnboardingData().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('OnboardingProvider: Timeout loading onboarding data');
          return [];
        },
      );

      debugPrint('OnboardingProvider: Loaded ${_pages.length} pages');
    } catch (e) {
      debugPrint('OnboardingProvider: Error loading onboarding data: $e');
      _errorMessage = 'Failed to load onboarding data';
      _pages = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Hàm reset dành cho debug, gọi thủ công nếu cần
  // Future<void> resetOnboarding() async {
  //   try {
  //     await repository.resetOnboarding();
  //     _isFirstLaunch = true;
  //     debugPrint('OnboardingProvider: Onboarding status reset');
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint('OnboardingProvider: Error resetting onboarding: $e');
  //   }
  // }
}
