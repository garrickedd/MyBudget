import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/features/finance/domain/entities/report_entity.dart';
import 'package:my_budget/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:my_budget/features/finance/presentation/bloc/finance_event.dart';
import 'package:my_budget/features/finance/presentation/bloc/finance_state.dart';

class ReportsPage extends StatelessWidget {
  final String userId;

  const ReportsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: BlocListener<FinanceBloc, FinanceState>(
        listener: (context, state) {
          if (state is FinanceError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReportForm(context),
              const SizedBox(height: 16.0),
              const Text(
                'Report Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              BlocBuilder<FinanceBloc, FinanceState>(
                builder: (context, state) {
                  if (state is FinanceLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ReportLoaded) {
                    final report = state.report;
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Month: ${report.month}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Total Income: \$${report.totalIncome.toStringAsFixed(2)}',
                            ),
                            Text(
                              'Total Expense: \$${report.totalExpense.toStringAsFixed(2)}',
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Jars:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...report.jars.map(
                              (jar) => Text(
                                '${jar.name}: \$${jar.balance.toStringAsFixed(2)}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is FinanceError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('No report available'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportForm(BuildContext context) {
    final monthController = TextEditingController(text: '2025-05');

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generate Report',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: monthController,
              decoration: const InputDecoration(labelText: 'Month (YYYY-MM)'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (monthController.text.isNotEmpty) {
                  context.read<FinanceBloc>().add(
                    GenerateReportEvent(userId, monthController.text),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a month')),
                  );
                }
              },
              child: const Text('Generate Report'),
            ),
          ],
        ),
      ),
    );
  }
}
