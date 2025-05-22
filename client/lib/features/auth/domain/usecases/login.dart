import 'package:flutter/foundation.dart';
import 'package:mybudget/core/network/api_client.dart';
import 'package:mybudget/core/utils/failure.dart';
import 'package:mybudget/features/auth/domain/entities/user.dart';
import 'package:mybudget/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<User> call(String email, String password) async {
    try {
      final apiClient = ApiClient();
      debugPrint(
        'Login: Sending login request for email: $email, password: $password',
      );
      final response = await apiClient.post('/users/login', {
        'email': email,
        'pass':
            password, // Khớp với định dạng Postman, có thể thay bằng 'password' nếu server yêu cầu
      });
      debugPrint('Login: Response from server: ${jsonEncode(response)}');
      return User.fromJson(response); // Giả định User có fromJson
    } catch (e) {
      debugPrint('Login: Error during login: $e');
      if (e is Failure && e.message.contains('401')) {
        throw Failure(message: 'Invalid email or password');
      }
      throw Failure(message: e.toString());
    }
  }
}

class Params extends Equatable {
  final String email;
  final String password;

  const Params({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
