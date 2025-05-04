// onboarding repository implementation

import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/auth/data/datasources/onboarding/onboarding_local_datasource.dart';
import 'package:my_budget/features/auth/domain/entities/onboarding/onboarding_entitiy.dart';
import 'package:my_budget/features/auth/domain/repositories/onboarding/onboarding_repository.dart';
import 'package:dartz/dartz.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<OnboardingEntitiy>>>
  getOnboardingContent() async {
    try {
      final content = localDataSource.getOnboardingContent();
      return Right(content);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
