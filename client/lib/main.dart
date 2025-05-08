import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/injection_container.dart' as di;
import 'package:my_budget/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:my_budget/features/finance/presentation/view/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Initialize dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyBudget',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => di.sl<FinanceBloc>(),
        child: const HomePage(
          userId: 'dungtran@email.com',
        ), // Replace with dynamic userId
      ),
    );
  }
}
