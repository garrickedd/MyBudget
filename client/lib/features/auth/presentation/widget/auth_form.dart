import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  const AuthForm({super.key, required this.isLogin});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text;
      final password = passwordController.text;

      if (widget.isLogin) {
        context.read<AuthBloc>().add(LoginRequested(email, password));
      } else {
        final user = User(
          id: '',
          email: email,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
        );
        context.read<AuthBloc>().add(RegisterRequested(user, password));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            if (!widget.isLogin) ...[
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator:
                    (value) => value!.isEmpty ? 'Enter your first name' : null,
              ),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator:
                    (value) => value!.isEmpty ? 'Enter your last name' : null,
              ),
            ],
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) => value!.isEmpty ? 'Enter your email' : null,
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator:
                  (value) =>
                      value!.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(widget.isLogin ? 'Login' : 'Register'),
            ),
          ],
        ),
      ),
    );
  }
}
