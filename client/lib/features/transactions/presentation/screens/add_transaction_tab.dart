import 'package:flutter/material.dart';

class AddTransactionTab extends StatelessWidget {
  const AddTransactionTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder: Hiện dialog khi tab được nhấn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Add Transaction'),
              content: const Text('Chức năng này sẽ được phát triển sau.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    });
    return const SizedBox.shrink(); // Không hiển thị nội dung trên màn hình
  }
}
