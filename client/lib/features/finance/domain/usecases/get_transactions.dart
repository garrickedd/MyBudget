import 'package:dartz/dartz.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/core/usecases/usecase.dart';
import 'package:my_budget/features/finance/domain/entities/transaction_entity.dart';
import 'package:my_budget/features/finance/domain/repositories/finance_repository.dart';

class GetTransactions implements UseCase<List<Transaction>, String> {
  final FinanceRepository repository;

  GetTransactions(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(String userId) async {
    return await repository.getTransactions(userId);
  }
}
