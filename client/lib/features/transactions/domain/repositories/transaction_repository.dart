import 'package:mybudget/features/transactions/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<void> createTransaction(Transaction transaction);
  Future<List<Transaction>> getUserTransactions(String userId);
}
