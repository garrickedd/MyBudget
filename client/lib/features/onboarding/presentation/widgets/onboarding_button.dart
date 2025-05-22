import 'package:flutter/material.dart';

class OnboardingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const OnboardingButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor:
            isPrimary ? Colors.white : Theme.of(context).primaryColor,
        backgroundColor:
            isPrimary ? Theme.of(context).primaryColor : Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side:
              isPrimary
                  ? BorderSide.none
                  : BorderSide(color: Theme.of(context).primaryColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
