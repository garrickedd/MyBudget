import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/auth/data/models/auth_response_model.dart';
import 'package:my_budget/features/auth/data/models/user_model.dart';

// import 'package:my_budget/features/auth/domain/entities/auth/auth_response_entity.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDatasource {
  final http.Client client;
  static const String baseUrl = 'http://localhost:8080/api/v1';

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'name': name}),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Registration failed';
      throw AuthFailure(error);
    }
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Login failed';
      throw AuthFailure(error);
    }
  }
}
