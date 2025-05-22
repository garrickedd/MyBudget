import 'package:mybudget/features/transactions/domain/entities/transaction.dart';
import 'package:mybudget/features/transactions/domain/repositories/transaction_repository.dart';

class GetUserTransactions {
  final TransactionRepository repository;

  GetUserTransactions(this.repository);

  Future<List<Transaction>> call(String userId) async {
    return await repository.getUserTransactions(userId);
  }
}