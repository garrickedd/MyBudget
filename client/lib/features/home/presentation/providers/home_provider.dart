import 'package:flutter/material.dart';
import 'package:mybudget/features/home/domain/entities/financial_summary.dart';
import 'package:mybudget/features/home/domain/usecases/get_financial_summary.dart';

class HomeProvider with ChangeNotifier {
  final GetFinancialSummary getFinancialSummary;
  bool _isLoading = false;
  String? _errorMessage;
  FinancialSummary _financialSummary = FinancialSummary(
    totalBalance: 0.0,
    income: 0.0,
    expense: 0.0,
  );

  HomeProvider({required this.getFinancialSummary});

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  FinancialSummary get financialSummary => _financialSummary;

  Future<void> fetchFinancials(String userId) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final summary = await getFinancialSummary(userId);
      _financialSummary = summary;
      _isLoading = false;
      notifyListeners();

      // Đảm bảo giao diện được làm mới sau khi dữ liệu thay đổi
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch financials: $e';
      notifyListeners();
    }
  }
}
