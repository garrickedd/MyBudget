import 'package:mybudget/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:mybudget/features/onboarding/data/models/onboarding_model.dart';
import 'package:mybudget/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> isFirstLaunch() async {
    return !(await localDataSource.checkIfFirstLaunch());
  }

  @override
  Future<void> completeOnboarding() async {
    await localDataSource.setOnboardingCompleted();
  }

  @override
  List<OnboardingModel> getOnboardingData() {
    return localDataSource.getOnboardingData();
  }
}
