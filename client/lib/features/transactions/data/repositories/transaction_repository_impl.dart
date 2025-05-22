import 'package:mybudget/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:mybudget/features/transactions/domain/entities/transaction.dart';
import 'package:mybudget/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createTransaction(Transaction transaction) {
    return remoteDataSource.createTransaction(transaction);
  }
}
