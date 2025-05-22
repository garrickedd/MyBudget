import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mybudget/injection_container.dart' as di;
import 'package:mybudget/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:mybudget/features/onboarding/presentation/screens/onboarding_screen.dart';
// import 'package:mybudget/features/auth/presentation/providers/auth_provider.dart';
// import 'package:mybudget/features/auth/presentation/screens/auth_check_screen.dart';
// import 'package:mybudget/features/auth/presentation/screens/login_screen.dart';
// import 'package:mybudget/features/auth/presentation/screens/register_screen.dart';
// import 'package:mybudget/features/dashboard/presentation/screens/dashboard_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<OnboardingProvider>()),
        // ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        // Thêm các provider khác tại đây
      ],
      child: MaterialApp(
        title: 'MyBudget',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
        ),
        home: const InitialScreen(),
        // routes: {
        //   '/login': (context) => const LoginScreen(),
        //   '/register': (context) => const RegisterScreen(),
        //   '/dashboard': (context) => const DashboardScreen(),
        // },
      ),
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onboardingProvider = Provider.of<OnboardingProvider>(
      context,
      listen: false,
    );

    return FutureBuilder<bool>(
      future: onboardingProvider.repository.isFirstLaunch(),
      builder: (context, snapshot) {
        return OnboardingScreen();
        // if (snapshot.connectionState == ConnectionState.done) {
        //   return snapshot.data == true
        //       ? const OnboardingScreen()
        //       : const AuthCheckScreen();
        // }
        // return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
