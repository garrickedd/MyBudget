import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Home - Tổng quan tài chính',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Số dư: 0 VNĐ', // Placeholder, sẽ tích hợp dữ liệu sau
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
