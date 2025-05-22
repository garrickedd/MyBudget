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

  OnboardingProvider({
    required this.checkOnboardingStatus,
    required this.completeOnboarding,
    required this.repository,
  });

  bool get isFirstLaunch => _isFirstLaunch;
  List<OnboardingPage> get pages => _pages;

  Future<void> checkStatus() async {
    _isFirstLaunch = await checkOnboardingStatus();
    notifyListeners();
  }

  Future<void> complete() async {
    await completeOnboarding();
    _isFirstLaunch = false;
    notifyListeners();
  }

  Future<void> loadOnboardingData() async {
    _pages = await repository.getOnboardingData();
    notifyListeners();
  }
}
