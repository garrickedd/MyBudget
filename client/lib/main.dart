import 'package:flutter/material.dart';
import 'package:mybudget/features/auth/domain/usecases/get_user.dart';
import 'package:mybudget/features/auth/domain/usecases/login.dart';
import 'package:mybudget/features/auth/domain/usecases/register.dart';
import 'package:mybudget/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:mybudget/features/onboarding/domain/usecases/check_onboarding_status.dart';
import 'package:mybudget/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:mybudget/injection_container.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:mybudget/features/auth/presentation/providers/auth_provider.dart';
import 'package:mybudget/features/auth/presentation/screens/login_screen.dart';
import 'package:mybudget/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:mybudget/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:mybudget/features/home/presentation/screens/home_screen.dart';

void main() {
  initDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => AuthProvider(
                register: getIt<Register>(),
                login: getIt<Login>(),
                getUser: getIt<GetUser>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => OnboardingProvider(
                checkOnboardingStatus: getIt<CheckOnboardingStatus>(),
                completeOnboarding: getIt<CompleteOnboarding>(),
                repository: getIt<OnboardingRepository>(),
              ),
        ),
      ],
      child: const MyBudgetApp(),
    ),
  );
}

class MyBudgetApp extends StatefulWidget {
  const MyBudgetApp({super.key});

  @override
  _MyBudgetAppState createState() => _MyBudgetAppState();
}

class _MyBudgetAppState extends State<MyBudgetApp> {
  late Future<bool> _checkStatusFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    _checkStatusFuture = provider.checkStatus().timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        debugPrint(
          'MyBudgetApp: Timeout checking onboarding status, defaulting to false',
        );
        return false;
      },
    );
    debugPrint('MyBudgetApp: Initialized checkStatus future');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyBudget',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/':
            (context) => FutureBuilder<bool>(
              future: _checkStatusFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  debugPrint('Main: Waiting for onboarding status');
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  debugPrint(
                    'Main: Error checking onboarding status: ${snapshot.error}',
                  );
                  return const Center(
                    child: Text('Error loading onboarding status'),
                  );
                }
                final isFirstLaunch = snapshot.data ?? false;
                debugPrint('Main: isFirstLaunch = $isFirstLaunch');
                return isFirstLaunch
                    ? const OnboardingScreen()
                    : const LoginScreen();
              },
            ),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
