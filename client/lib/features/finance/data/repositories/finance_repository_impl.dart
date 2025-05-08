import 'package:dartz/dartz.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/finance/data/datasources/finance_remote_datasource.dart';
import 'package:my_budget/features/finance/domain/entities/budget_entity.dart';
import 'package:my_budget/features/finance/domain/entities/jar_entity.dart';
import 'package:my_budget/features/finance/domain/entities/report_entity.dart';
import 'package:my_budget/features/finance/domain/entities/transaction_entity.dart';
import 'package:my_budget/features/finance/domain/repositories/finance_repository.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final FinanceRemoteDataSource remoteDataSource;

  FinanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Jar>>> getJars(String userId) async {
    try {
      final jars = await remoteDataSource.getJars(userId);
      return Right(jars as List<Jar>);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> recordIncome(
    String userId,
    double amount,
    String description,
  ) async {
    try {
      await remoteDataSource.recordIncome(userId, amount, description);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> recordExpense(
    String userId,
    int jarId,
    double amount,
    String description,
  ) async {
    try {
      await remoteDataSource.recordExpense(userId, jarId, amount, description);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions(
    String userId,
  ) async {
    try {
      final transactions = await remoteDataSource.getTransactions(userId);
      return Right(transactions as List<Transaction>);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> createBudget(
    String userId,
    int jarId,
    double amount,
    String month,
  ) async {
    try {
      await remoteDataSource.createBudget(userId, jarId, amount, month);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Budget>>> getBudgets(
    String userId,
    String month,
  ) async {
    try {
      final budgets = await remoteDataSource.getBudgets(userId, month);
      return Right(budgets as List<Budget>);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Report>> generateReport(
    String userId,
    String month,
  ) async {
    try {
      final report = await remoteDataSource.generateReport(userId, month);
      return Right(report);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
