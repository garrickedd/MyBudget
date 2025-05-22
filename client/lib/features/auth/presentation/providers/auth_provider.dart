import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mybudget/core/utils/failure.dart';
import 'package:mybudget/features/auth/domain/entities/user.dart';
import 'package:mybudget/features/auth/domain/usecases/login.dart';
import 'package:mybudget/features/auth/domain/usecases/register.dart';
import 'package:mybudget/features/auth/domain/usecases/get_user.dart';

class AuthProvider extends ChangeNotifier {
  final Login login;
  final Register register;
  final GetUser getUser;

  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  AuthProvider({
    required this.login,
    required this.register,
    required this.getUser,
  });

  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<String?> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      debugPrint(
        'AuthProvider: Signing in with email: $email, password: $password',
      );

      final user = await login(email, password);
      _user = user;
      debugPrint('AuthProvider: Sign in successful, user: $_user');
      return null;
    } catch (e) {
      debugPrint('AuthProvider: Sign in error: $e');
      if (e is Failure && e.message.contains('401')) {
        _errorMessage = 'Invalid email or password';
      } else {
        _errorMessage = e is Failure ? e.message : 'An error occurred';
      }
      return _errorMessage;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> signUp(String name, String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      debugPrint(
        'AuthProvider: Signing up with name: $name, email: $email, password: $password',
      );

      final user = await register(name, email, password);
      _user = user;
      debugPrint('AuthProvider: Sign up successful, user: $_user');
      return null;
    } catch (e) {
      debugPrint('AuthProvider: Sign up error: $e');
      if (e is Failure && e.message.contains('401')) {
        _errorMessage = 'Sign up failed: Invalid credentials';
      } else {
        _errorMessage = e is Failure ? e.message : 'An error occurred';
      }
      return _errorMessage;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUser(String id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      debugPrint('AuthProvider: Fetching user with id: $id');

      final user = await getUser(id);
      _user = user;
      debugPrint('AuthProvider: Fetch user successful, user: $_user');
    } catch (e) {
      debugPrint('AuthProvider: Fetch user error: $e');
      _errorMessage = e is Failure ? e.message : 'Failed to fetch user: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      debugPrint('AuthProvider: Logging out user');

      _user = null;
      _errorMessage = null;
      debugPrint('AuthProvider: Logout successful');
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      debugPrint('AuthProvider: Logout error: $e');
      _errorMessage = e is Failure ? e.message : 'An error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
