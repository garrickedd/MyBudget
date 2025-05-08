import 'package:dio/dio.dart';
import 'package:my_budget/features/finance/data/models/budget_model.dart';
import 'package:my_budget/features/finance/data/models/jar_model.dart';
import 'package:my_budget/features/finance/data/models/report_model.dart';
import 'package:my_budget/features/finance/data/models/transaction_model.dart';

class FinanceRemoteDataSourceImpl implements FinanceRemoteDataSource {
  final Dio dio;

  FinanceRemoteDataSourceImpl(this.dio);

  @override
  Future<List<JarModel>> getJars(String userId) async {
    try {
      final response = await dio.get(
        '/api/v1/jars',
        queryParameters: {'user_id': userId},
      );
      final data = response.data as List<dynamic>;
      return data
          .map((json) => JarModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch jars: $e');
    }
  }

  @override
  Future<void> recordIncome(
    String userId,
    double amount,
    String description,
  ) async {
    try {
      await dio.post(
        '/api/v1/transactions/income',
        data: {'user_id': userId, 'amount': amount, 'description': description},
      );
    } catch (e) {
      throw Exception('Failed to record income: $e');
    }
  }

  @override
  Future<void> recordExpense(
    String userId,
    int jarId,
    double amount,
    String description,
  ) async {
    try {
      await dio.post(
        '/api/v1/transactions/expense',
        data: {
          'user_id': userId,
          'jar_id': jarId,
          'amount': amount,
          'description': description,
        },
      );
    } catch (e) {
      throw Exception('Failed to record expense: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions(String userId) async {
    try {
      final response = await dio.get(
        '/api/v1/transactions',
        queryParameters: {'user_id': userId},
      );
      final data = response.data as List<dynamic>;
      return data
          .map(
            (json) => TransactionModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  @override
  Future<void> createBudget(
    String userId,
    int jarId,
    double amount,
    String month,
  ) async {
    try {
      await dio.post(
        '/api/v1/budgets',
        data: {
          'user_id': userId,
          'jar_id': jarId,
          'amount': amount,
          'month': month,
        },
      );
    } catch (e) {
      throw Exception('Failed to create budget: $e');
    }
  }

  @override
  Future<List<BudgetModel>> getBudgets(String userId, String month) async {
    try {
      final response = await dio.get(
        '/api/v1/budgets',
        queryParameters: {'user_id': userId, 'month': month},
      );
      final data = response.data as List<dynamic>;
      return data
          .map((json) => BudgetModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch budgets: $e');
    }
  }

  @override
  Future<ReportModel> generateReport(String userId, String month) async {
    try {
      final response = await dio.get(
        '/api/v1/reports',
        queryParameters: {'user_id': userId, 'month': month},
      );
      return ReportModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to generate report: $e');
    }
  }
}

abstract class FinanceRemoteDataSource {
  Future<List<JarModel>> getJars(String userId);
  Future<void> recordIncome(String userId, double amount, String description);
  Future<void> recordExpense(
    String userId,
    int jarId,
    double amount,
    String description,
  );
  Future<List<TransactionModel>> getTransactions(String userId);
  Future<void> createBudget(
    String userId,
    int jarId,
    double amount,
    String month,
  );
  Future<List<BudgetModel>> getBudgets(String userId, String month);
  Future<ReportModel> generateReport(String userId, String month);
}
