import 'package:dartz/dartz.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/core/usecases/usecase.dart';
import 'package:my_budget/features/finance/domain/repositories/finance_repository.dart';

class RecordExpense implements UseCase<Unit, RecordExpenseParams> {
  final FinanceRepository repository;

  RecordExpense(this.repository);

  @override
  Future<Either<Failure, Unit>> call(RecordExpenseParams params) async {
    return await repository.recordExpense(
      params.userId,
      params.jarId,
      params.amount,
      params.description,
    );
  }
}

class RecordExpenseParams {
  final String userId;
  final int jarId;
  final double amount;
  final String description;

  RecordExpenseParams({
    required this.userId,
    required this.jarId,
    required this.amount,
    required this.description,
  });
}
