import 'package:mybudget/core/network/api_client.dart';
import 'package:mybudget/features/home/domain/entities/financial_summary.dart';

class HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSource(this._apiClient);

  Future<FinancialSummary> getFinancialSummary(String userId) async {
    try {
      final response = await _apiClient.get('/financials?user_id=$userId');
      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format: Expected a Map');
      }
      return FinancialSummary(
        totalBalance: (response['totalBalance'] as num?)?.toDouble() ?? 0.0,
        income: (response['income'] as num?)?.toDouble() ?? 0.0,
        expense: (response['expense'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      throw Exception('Failed to load financials: $e');
    }
  }
}
