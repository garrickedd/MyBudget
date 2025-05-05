// abstract interface to get content onboarding
import 'package:dartz/dartz.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/onboarding/domain/entities/onboarding_entitiy.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, List<OnboardingEntitiy>>> getOnboardingContent();
}
