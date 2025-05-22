import 'package:mybudget/features/auth/domain/entities/user.dart';
import 'package:mybudget/features/auth/domain/repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<User> call(String name, String email, String password) async {
    return await repository.register(name, email, password);
  }
}
