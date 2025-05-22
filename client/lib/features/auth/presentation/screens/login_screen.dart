import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';
import 'package:mybudget/features/auth/presentation/providers/auth_provider.dart';
import 'package:mybudget/features/home/presentation/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data, BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.signIn(data.name, data.password);
  }

  Future<String?> _signupUser(SignupData data, BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.signUp(
      data.name ?? '',
      data.name ?? '', // Sử dụng email làm username
      data.password ?? '',
    );
  }

  Future<String?> _recoverPassword(String name) {
    // TODO: Implement password recovery
    return Future.delayed(loginTime).then((_) => 'Not implemented');
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage('assets/images/logo.png'),
      onLogin: (data) => _authUser(data, context),
      onSignup: (data) => _signupUser(data, context),
      onSubmitAnimationCompleted: () {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.user != null) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
        userHint: 'Email',
        passwordHint: 'Password',
        signupButton: 'Register',
        loginButton: 'Login',
        recoverPasswordButton: 'Forgot Password',
      ),
      theme: LoginTheme(
        primaryColor: Theme.of(context).primaryColor,
        accentColor: Colors.white,
        titleStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}
