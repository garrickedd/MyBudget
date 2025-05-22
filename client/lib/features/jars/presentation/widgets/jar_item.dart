import 'package:flutter/material.dart';
import 'package:mybudget/features/jars/domain/entities/jar.dart';

class JarItem extends StatelessWidget {
  final Jar jar;

  const JarItem({super.key, required this.jar});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.account_balance_wallet, color: Colors.blue),
        title: Text(jar.name),
        subtitle: Text(
          'Balance: ${jar.balance.toStringAsFixed(2)} VNĐ\nPercentage: ${jar.percentage.toStringAsFixed(2)}%',
        ),
        trailing: Text('ID: ${jar.id ?? "N/A"}'),
      ),
    );
  }
}
