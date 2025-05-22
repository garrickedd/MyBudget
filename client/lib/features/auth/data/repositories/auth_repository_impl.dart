import 'package:mybudget/core/network/api_client.dart';
import 'package:mybudget/core/utils/failure.dart';
import 'package:mybudget/features/auth/data/models/user_model.dart';
import 'package:mybudget/features/auth/domain/entities/user.dart';
import 'package:mybudget/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl(this.apiClient);

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await apiClient.post('/users/login', {
        'email': email,
        'password': password,
      }, includeToken: false);
      return UserModel.fromJson(response['user']).toEntity();
    } catch (e) {
      throw Failure(message: e.toString());
    }
  }

  @override
  Future<User> register(String name, String email, String password) async {
    try {
      final response = await apiClient.post('/users/register', {
        'name': name,
        'email': email,
        'password': password,
      }, includeToken: false);
      return UserModel.fromJson(response['user']).toEntity();
    } catch (e) {
      throw Failure(message: e.toString());
    }
  }

  @override
  Future<User> getUser(String id) async {
    try {
      final response = await apiClient.get('/users/$id');
      return UserModel.fromJson(response['user']).toEntity();
    } catch (e) {
      throw Failure(message: e.toString());
    }
  }
}
