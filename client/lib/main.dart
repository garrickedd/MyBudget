import 'package:flutter/material.dart';
import 'package:my_budget/features/auth/presentation/view/login_page.dart';
import 'package:my_budget/features/auth/presentation/view/register_page.dart';
import 'package:my_budget/features/onboarding/presentation/view/onboarding_page.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/auth_service.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyBudget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: FutureBuilder(
        future: _determineInitialRoute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data as Widget;
        },
      ),
      routes: {
        '/onboarding': (context) => const OnboardingPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }

  Future<Widget> _determineInitialRoute() async {
    final authService = di.sl<AuthService>();
    final isOnboardingCompleted = await authService.isOnboardingCompleted();
    final token = await authService.getToken();

    if (!isOnboardingCompleted) {
      return const OnboardingPage();
    } else if (token == null) {
      return const LoginPage();
    } else {
      return const HomePage();
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to MyBudget!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await di.sl<AuthService>().clearToken();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
