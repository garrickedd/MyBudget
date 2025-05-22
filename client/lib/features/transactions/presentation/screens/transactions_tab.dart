import 'package:flutter/material.dart';

class TransactionsTab extends StatelessWidget {
  const TransactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Transactions - Danh sách giao dịch',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có giao dịch nào', // Placeholder
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
