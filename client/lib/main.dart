import 'package:flutter/material.dart';
import 'package:mybudget/features/home/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:mybudget/features/auth/presentation/providers/auth_provider.dart';
import 'package:mybudget/features/auth/presentation/screens/login_screen.dart';
import 'package:mybudget/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:mybudget/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:mybudget/features/home/presentation/screens/home_screen.dart';
import 'package:mybudget/features/jars/presentation/providers/jars_provider.dart';
import 'package:mybudget/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const MyBudgetApp());
}

class MyBudgetApp extends StatelessWidget {
  const MyBudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.getIt<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.getIt<OnboardingProvider>()),
        ChangeNotifierProvider(create: (_) => di.getIt<JarsProvider>()),
        ChangeNotifierProvider(create: (_) => di.getIt<HomeProvider>()),
      ],
      child: const AppInitializer(),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late Future<bool> _checkStatusFuture;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    _checkStatusFuture = provider.checkStatus().timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        debugPrint(
          'AppInitializer: Timeout checking onboarding status, defaulting to false',
        );
        return false;
      },
    );
    debugPrint('AppInitializer: Initialized checkStatus future');
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
                  debugPrint('AppInitializer: Waiting for onboarding status');
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  debugPrint(
                    'AppInitializer: Error checking onboarding status: ${snapshot.error}',
                  );
                  return const Center(
                    child: Text('Error loading onboarding status'),
                  );
                }
                final isFirstLaunch = snapshot.data ?? false;
                debugPrint('AppInitializer: isFirstLaunch = $isFirstLaunch');
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
