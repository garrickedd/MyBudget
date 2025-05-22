import 'package:mybudget/features/transactions/domain/entities/transaction.dart';
import 'package:mybudget/features/transactions/domain/repositories/transaction_repository.dart';

class CreateTransaction {
  final TransactionRepository repository;

  CreateTransaction(this.repository);

  Future<void> call(Transaction transaction) {
    return repository.createTransaction(transaction);
  }
}
