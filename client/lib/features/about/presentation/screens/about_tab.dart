import 'package:flutter/material.dart';

class AboutTab extends StatelessWidget {
  const AboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Thông tin nhà phát triển',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text('Ứng dụng: MyBudget', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              const Text('Phiên bản: 1.0.0', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              const Text(
                'Nhà phát triển: [Tên nhà phát triển]',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                'Email hỗ trợ: support@mybudget.com',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                '© 2025 MyBudget. All rights reserved.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
