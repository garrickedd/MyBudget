import 'package:flutter/material.dart';
import 'package:mybudget/features/transactions/domain/entities/transaction.dart';
import 'package:mybudget/features/transactions/domain/usecases/create_transaction.dart';
import 'package:mybudget/features/home/presentation/providers/home_provider.dart';
import 'package:mybudget/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class TransactionProvider with ChangeNotifier {
  final CreateTransaction createTransaction;
  bool _isLoading = false;
  String? _errorMessage;

  TransactionProvider({required this.createTransaction});

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> addTransaction(
    Transaction transaction,
    BuildContext context,
  ) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await createTransaction(transaction);

      // Làm mới dữ liệu tài chính từ HomeProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id.toString();
      if (userId != null) {
        final homeProvider = Provider.of<HomeProvider>(context, listen: false);
        await homeProvider.fetchFinancials(userId);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to add transaction: $e';
      notifyListeners();
      throw e; // Ném lỗi để AddTransactionTab xử lý
    }
  }
}
