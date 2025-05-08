import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/features/finance/domain/entities/budget_entity.dart';
import 'package:my_budget/features/finance/domain/entities/jar_entity.dart';
import 'package:my_budget/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:my_budget/features/finance/presentation/bloc/finance_event.dart';
import 'package:my_budget/features/finance/presentation/bloc/finance_state.dart';

class BudgetsPage extends StatelessWidget {
  final String userId;

  const BudgetsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Trigger loading budgets
    context.read<FinanceBloc>().add(GetBudgetsEvent(userId, '2025-05'));

    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
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
            // Refresh budgets after success
            context.read<FinanceBloc>().add(GetBudgetsEvent(userId, '2025-05'));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBudgetForm(context),
              const SizedBox(height: 16.0),
              const Text(
                'Current Budgets',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              BlocBuilder<FinanceBloc, FinanceState>(
                builder: (context, state) {
                  if (state is FinanceLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BudgetsLoaded) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.budgets.length,
                      itemBuilder: (context, index) {
                        final budget = state.budgets[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text('Jar ID: ${budget.jarId}'),
                            subtitle: Text(
                              'Amount: \$${budget.amount.toStringAsFixed(2)}\nMonth: ${budget.month}',
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is FinanceError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('No budgets available'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetForm(BuildContext context) {
    final amountController = TextEditingController();
    final monthController = TextEditingController(text: '2025-05');
    int? selectedJarId;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Budget',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: monthController,
              decoration: const InputDecoration(labelText: 'Month (YYYY-MM)'),
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
                    monthController.text.isNotEmpty &&
                    selectedJarId != null) {
                  context.read<FinanceBloc>().add(
                    CreateBudgetEvent(
                      userId,
                      selectedJarId!,
                      amount,
                      monthController.text,
                    ),
                  );
                  amountController.clear();
                  monthController.text = '2025-05';
                  selectedJarId = null;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: const Text('Create Budget'),
            ),
          ],
        ),
      ),
    );
  }
}
