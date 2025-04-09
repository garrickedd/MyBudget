import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<void> call(User user, String password) {
    return repository.register(user, password);
  }
}
