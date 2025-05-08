import 'package:dartz/dartz.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/core/usecases/usecase.dart';
import 'package:my_budget/features/finance/domain/repositories/finance_repository.dart';

class RecordIncome implements UseCase<Unit, RecordIncomeParams> {
  final FinanceRepository repository;

  RecordIncome(this.repository);

  @override
  Future<Either<Failure, Unit>> call(RecordIncomeParams params) async {
    return await repository.recordIncome(
      params.userId,
      params.amount,
      params.description,
    );
  }
}

class RecordIncomeParams {
  final String userId;
  final double amount;
  final String description;

  RecordIncomeParams({
    required this.userId,
    required this.amount,
    required this.description,
  });
}
