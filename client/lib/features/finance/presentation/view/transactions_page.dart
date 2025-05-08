import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/features/finance/domain/entities/jar_entity.dart';
import 'package:my_budget/features/finance/domain/entities/transaction_entity.dart';
import 'package:my_budget/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:my_budget/features/finance/presentation/bloc/finance_event.dart';
import 'package:my_budget/features/finance/presentation/bloc/finance_state.dart';

class TransactionsPage extends StatelessWidget {
  final String userId;

  const TransactionsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Trigger loading transactions
    context.read<FinanceBloc>().add(GetTransactionsEvent(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: BlocListener<FinanceBloc, FinanceState>(
        listener: (context, state) {
          if (state is FinanceError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is FinanceSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            // Refresh transactions after success
            context.read<FinanceBloc>().add(GetTransactionsEvent(userId));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIncomeForm(context),
              const SizedBox(height: 16.0),
              _buildExpenseForm(context),
              const SizedBox(height: 16.0),
              const Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              BlocBuilder<FinanceBloc, FinanceState>(
                builder: (context, state) {
                  if (state is FinanceLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TransactionsLoaded) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = state.transactions[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              '${transaction.type.toUpperCase()}: \$${transaction.amount.toStringAsFixed(2)}',
                            ),
                            subtitle: Text(
                              '${transaction.description}\n${transaction.createdAt.toString()}',
                            ),
                            trailing:
                                transaction.jarId != null
                                    ? Text('Jar ID: ${transaction.jarId}')
                                    : null,
                          ),
                        );
                      },
                    );
                  } else if (state is FinanceError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('No transactions available'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeForm(BuildContext context) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Record Income',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null && descriptionController.text.isNotEmpty) {
                  context.read<FinanceBloc>().add(
                    RecordIncomeEvent(
                      userId,
                      amount,
                      descriptionController.text,
                    ),
                  );
                  amountController.clear();
                  descriptionController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter valid amount and description',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Submit Income'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseForm(BuildContext context) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    int? selectedJarId;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Record Expense',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            BlocBuilder<FinanceBloc, FinanceState>(
              builder: (context, state) {
                List<Jar> jars = [];
                if (state is JarsLoaded) {
                  jars = state.jars;
                }
                return DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Select Jar'),
                  items:
                      jars.map((jar) {
                        return DropdownMenuItem<int>(
                          value: jar.id,
                          child: Text(jar.name),
                        );
                      }).toList(),
                  onChanged: (value) {
                    selectedJarId = value;
                  },
                );
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null &&
                    descriptionController.text.isNotEmpty &&
                    selectedJarId != null) {
                  context.read<FinanceBloc>().add(
                    RecordExpenseEvent(
                      userId,
                      selectedJarId!,
                      amount,
                      descriptionController.text,
                    ),
                  );
                  amountController.clear();
                  descriptionController.clear();
                  selectedJarId = null;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: const Text('Submit Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
