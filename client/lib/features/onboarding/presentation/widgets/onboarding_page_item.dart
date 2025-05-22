import 'package:flutter/material.dart';
import 'package:mybudget/features/onboarding/data/models/onboarding_model.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel item;
  final bool isLastPage;

  const OnboardingPageItem({
    Key? key,
    required this.item,
    required this.isLastPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Image.asset(item.image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 32),
          Text(
            item.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              item.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          if (isLastPage) ...[
            const SizedBox(height: 24),
            const Text(
              'Bắt đầu hành trình quản lý tài chính ngay!',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
