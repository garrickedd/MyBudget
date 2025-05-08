import 'package:dartz/dartz.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/core/usecases/usecase.dart';
import 'package:my_budget/features/finance/domain/entities/budget_entity.dart';
import 'package:my_budget/features/finance/domain/repositories/finance_repository.dart';

class GetBudgets implements UseCase<List<Budget>, GetBudgetsParams> {
  final FinanceRepository repository;

  GetBudgets(this.repository);

  @override
  Future<Either<Failure, List<Budget>>> call(GetBudgetsParams params) async {
    return await repository.getBudgets(params.userId, params.month);
  }
}

class GetBudgetsParams {
  final String userId;
  final String month;

  GetBudgetsParams({required this.userId, required this.month});
}
