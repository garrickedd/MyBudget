// usecase to get content onboarding
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:my_budget/features/onboarding/domain/entities/onboarding_entitiy.dart';
import 'package:my_budget/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingContent
    implements UseCase<List<OnboardingEntitiy>, NoParams> {
  final OnboardingRepository repository;
  GetOnboardingContent(this.repository);

  @override
  Future<Either<Failure, List<OnboardingEntitiy>>> call(NoParams params) async {
    return await repository.getOnboardingContent();
  }
}
