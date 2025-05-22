import 'package:flutter/material.dart';

class JarsTab extends StatelessWidget {
  const JarsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Jars - Quản lý hũ tài chính',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có hũ nào', // Placeholder
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
