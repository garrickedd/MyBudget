import 'package:flutter/material.dart';
import '../widget/auth_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: AuthForm(isLogin: false),
    );
  }
}
