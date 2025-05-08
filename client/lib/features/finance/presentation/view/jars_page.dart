import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/features/finance/domain/entities/jar_entity.dart';
import 'package:my_budget/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:my_budget/features/finance/presentation/bloc/finance_event.dart';
import 'package:my_budget/features/finance/presentation/bloc/finance_state.dart';

class JarsPage extends StatelessWidget {
  final String userId;

  const JarsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Trigger loading jars
    context.read<FinanceBloc>().add(GetJarsEvent(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('Jars')),
      body: BlocBuilder<FinanceBloc, FinanceState>(
        builder: (context, state) {
          if (state is FinanceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JarsLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.jars.length,
              itemBuilder: (context, index) {
                final jar = state.jars[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      jar.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'Balance: \$${jar.balance.toStringAsFixed(2)}\nPercentage: ${jar.percentage}%',
                    ),
                  ),
                );
              },
            );
          } else if (state is FinanceError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No jars available'));
        },
      ),
    );
  }
}
