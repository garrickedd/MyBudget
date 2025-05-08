import 'package:dartz/dartz.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/finance/domain/entities/budget_entity.dart';
import 'package:my_budget/features/finance/domain/entities/jar_entity.dart';
import 'package:my_budget/features/finance/domain/entities/report_entity.dart';
import 'package:my_budget/features/finance/domain/entities/transaction_entity.dart';

abstract class FinanceRepository {
  Future<Either<Failure, List<Jar>>> getJars(String userId);
  Future<Either<Failure, Unit>> recordIncome(
    String userId,
    double amount,
    String description,
  );
  Future<Either<Failure, Unit>> recordExpense(
    String userId,
    int jarId,
    double amount,
    String description,
  );
  Future<Either<Failure, List<Transaction>>> getTransactions(String userId);
  Future<Either<Failure, Unit>> createBudget(
    String userId,
    int jarId,
    double amount,
    String month,
  );
  Future<Either<Failure, List<Budget>>> getBudgets(String userId, String month);
  Future<Either<Failure, Report>> generateReport(String userId, String month);
}
