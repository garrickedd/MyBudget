import 'package:mybudget/core/network/api_client.dart';
import 'package:mybudget/features/transactions/domain/entities/transaction.dart';

class TransactionRemoteDataSource {
  final ApiClient _apiClient;

  TransactionRemoteDataSource(this._apiClient);

  Future<void> createTransaction(Transaction transaction) async {
    final data = {
      'user_id': transaction.userId,
      'jar_id': transaction.jarId,
      'amount': transaction.amount,
      'description': transaction.description,
      'transaction_date': transaction.transactionDate.toIso8601String(),
    };
    try {
      final endpoint =
          transaction.type == 'income'
              ? '/transactions/income'
              : '/transactions/expense';
      if (transaction.type == 'income') {
        // Income không cần jar_id
        data.remove('jar_id');
      }
      await _apiClient.post(endpoint, data);
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }
}
