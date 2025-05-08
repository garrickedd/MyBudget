import 'package:dartz/dartz.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/core/usecases/usecase.dart';
import 'package:my_budget/features/finance/domain/repositories/finance_repository.dart';

class CreateBudget implements UseCase<Unit, CreateBudgetParams> {
  final FinanceRepository repository;

  CreateBudget(this.repository);

  @override
  Future<Either<Failure, Unit>> call(CreateBudgetParams params) async {
    return await repository.createBudget(
      params.userId,
      params.jarId,
      params.amount,
      params.month,
    );
  }
}

class CreateBudgetParams {
  final String userId;
  final int jarId;
  final double amount;
  final String month;

  CreateBudgetParams({
    required this.userId,
    required this.jarId,
    required this.amount,
    required this.month,
  });
}
