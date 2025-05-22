import 'package:flutter/material.dart';
import 'package:mybudget/features/transactions/domain/entities/transaction.dart';
import 'package:mybudget/features/transactions/domain/usecases/create_transaction.dart';
import 'package:mybudget/features/transactions/domain/usecases/get_user_transactions.dart';
import 'package:mybudget/features/home/presentation/providers/home_provider.dart';
import 'package:mybudget/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class TransactionProvider with ChangeNotifier {
  final CreateTransaction createTransaction;
  final GetUserTransactions getUserTransactions;
  bool _isLoading = false;
  String? _errorMessage;
  List<Transaction> _transactions = [];

  TransactionProvider({
    required this.createTransaction,
    required this.getUserTransactions,
  });

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Transaction> get transactions => _transactions;

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

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id.toString();
      if (userId != null) {
        final homeProvider = Provider.of<HomeProvider>(context, listen: false);
        await homeProvider.fetchFinancials(userId);
        await fetchTransactions(userId); // Làm mới danh sách giao dịch
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to add transaction: $e';
      notifyListeners();
      throw e;
    }
  }

  Future<void> fetchTransactions(String userId) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _transactions = await getUserTransactions(userId);
      _transactions.sort(
        (a, b) => b.transactionDate.compareTo(a.transactionDate),
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch transactions: $e';
      notifyListeners();
    }
  }
}
