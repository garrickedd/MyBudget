import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mybudget/features/auth/presentation/providers/auth_provider.dart';
import 'package:mybudget/features/transactions/presentation/providers/transaction_provider.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionProvider = Provider.of<TransactionProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id.toString();
      if (userId != null) {
        transactionProvider.fetchTransactions(userId);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in')));
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Transaction History'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                transactionProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : transactionProvider.errorMessage != null
                    ? Center(child: Text(transactionProvider.errorMessage!))
                    : transactionProvider.transactions.isEmpty
                    ? const Center(child: Text('No transactions available'))
                    : RefreshIndicator(
                      onRefresh: () async {
                        final authProvider = Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        );
                        final userId = authProvider.user?.id.toString();
                        if (userId != null) {
                          await transactionProvider.fetchTransactions(userId);
                        }
                      },
                      child: ListView.builder(
                        itemCount: transactionProvider.transactions.length,
                        itemBuilder: (context, index) {
                          final transaction =
                              transactionProvider.transactions[index];
                          final isIncome = transaction.type == 'income';
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Icon(
                                isIncome
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: isIncome ? Colors.teal : Colors.red,
                              ),
                              title: Text(
                                transaction.description,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat(
                                  'dd-MM-yyyy',
                                ).format(transaction.transactionDate),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              trailing: Text(
                                '₹${transaction.amount.toStringAsFixed(1)}',
                                style: TextStyle(
                                  color: isIncome ? Colors.teal : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
          ),
        );
      },
    );
  }
}
