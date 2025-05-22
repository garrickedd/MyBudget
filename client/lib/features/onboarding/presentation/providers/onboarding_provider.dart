import 'package:flutter/foundation.dart';
import 'package:mybudget/features/onboarding/data/models/onboarding_model.dart';
import 'package:mybudget/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingProvider with ChangeNotifier {
  final OnboardingRepository repository;

  int _currentPage = 0;
  List<OnboardingModel> _onboardingData = [];
  bool _isLoading = false;

  OnboardingProvider({required this.repository}) {
    _loadOnboardingData();
  }

  int get currentPage => _currentPage;
  List<OnboardingModel> get onboardingData => _onboardingData;
  bool get isLoading => _isLoading;

  Future<void> _loadOnboardingData() async {
    _isLoading = true;
    notifyListeners();

    _onboardingData = repository.getOnboardingData();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await repository.completeOnboarding();
  }

  void updateCurrentPage(int index) {
    _currentPage = index;
    notifyListeners();
  }
}
