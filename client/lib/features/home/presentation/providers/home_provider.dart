import 'package:flutter/material.dart';
import 'package:mybudget/features/home/domain/usecases/get_financial_summary.dart';
import 'package:mybudget/features/home/domain/entities/financial_summary.dart';

class HomeProvider with ChangeNotifier {
  final GetFinancialSummary getFinancialSummary;
  FinancialSummary _financialSummary = FinancialSummary.empty();
  bool _isLoading = false;
  String? _errorMessage;

  HomeProvider({required this.getFinancialSummary});

  FinancialSummary get financialSummary => _financialSummary;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load financials: $e';
      notifyListeners();
    }
  }
}
