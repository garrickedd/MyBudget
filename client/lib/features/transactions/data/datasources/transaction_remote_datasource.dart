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
        data.remove('jar_id');
      }
      await _apiClient.post(endpoint, data);
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  Future<List<Transaction>> getUserTransactions(String userId) async {
    try {
      final response = await _apiClient.get('/transactions?user_id=$userId');
      if (response is! List) {
        throw Exception('Invalid response format: Expected a List');
      }
      return response
          .map(
            (json) => Transaction(
              userId: json['user_id']?.toString() ?? '',
              jarId: json['jar_id'] ?? 0,
              type: json['type'] ?? '',
              amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
              description: json['description'] ?? '',
              transactionDate: DateTime.parse(
                json['transaction_date'] ?? DateTime.now().toIso8601String(),
              ),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }
}
