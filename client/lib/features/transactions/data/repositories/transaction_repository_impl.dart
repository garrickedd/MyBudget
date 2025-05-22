import 'package:mybudget/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:mybudget/features/transactions/domain/entities/transaction.dart';
import 'package:mybudget/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createTransaction(Transaction transaction) async {
    try {
      await remoteDataSource.createTransaction(transaction);
    } catch (e) {
      throw Exception('Failed to create transaction in repository: $e');
    }
  }

  @override
  Future<List<Transaction>> getUserTransactions(String userId) async {
    try {
      return await remoteDataSource.getUserTransactions(userId);
    } catch (e) {
      throw Exception('Failed to fetch transactions in repository: $e');
    }
  }
}
