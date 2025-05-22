import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';
import 'package:mybudget/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data, BuildContext context) {
    return Provider.of<AuthProvider>(
      context,
      listen: false,
    ).signIn(data.name, data.password);
  }

  Future<String?> _signupUser(SignupData data, BuildContext context) {
    return Provider.of<AuthProvider>(
      context,
      listen: false,
    ).signUp(data.name ?? '', data.name ?? '', data.password ?? '');
  }

  Future<String?> _recoverPassword(String name) {
    // TODO: Implement password recovery
    return Future.delayed(loginTime).then((_) => 'Not implemented');
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      // title: 'MyBudget',
      logo: const AssetImage('assets/images/logo.png'),
      onLogin: (data) => _authUser(data, context),
      onSignup: (data) => _signupUser(data, context),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Welcome to MyBudget!')),
    );
  }
}
