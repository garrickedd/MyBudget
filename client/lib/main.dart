// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/view/login_page.dart';
import 'features/auth/presentation/view/register_page.dart';
import 'features/auth/presentation/view/welcome_page.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';

void main() {
  final client = http.Client();
  final remoteDataSource = AuthRemoteDataSource(client);
  final authRepository = AuthRepositoryImpl(remoteDataSource);

  runApp(
    MyApp(
      authBloc: AuthBloc(
        loginUseCase: Login(authRepository),
        registerUseCase: Register(authRepository),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;

  const MyApp({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyBudget App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider.value(value: authBloc, child: const WelcomePage()),
      routes: {
        '/login':
            (_) =>
                BlocProvider.value(value: authBloc, child: const LoginPage()),
        '/register':
            (_) => BlocProvider.value(
              value: authBloc,
              child: const RegisterPage(),
            ),
      },
    );
  }
}
