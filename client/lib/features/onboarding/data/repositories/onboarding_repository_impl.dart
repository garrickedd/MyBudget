// onboarding repository implementation

import 'package:my_budget/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:my_budget/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:my_budget/features/onboarding/domain/entities/onboarding_entitiy.dart';
import 'package:my_budget/features/onboarding/domain/repositories/onboarding_repository.dart';

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
