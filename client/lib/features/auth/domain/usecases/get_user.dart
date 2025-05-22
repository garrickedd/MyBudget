import 'package:mybudget/features/auth/domain/entities/user.dart';
import 'package:mybudget/features/auth/domain/repositories/auth_repository.dart';

class GetUser {
  final AuthRepository repository;

  GetUser(this.repository);

  Future<User> call(String id) async {
    return await repository.getUser(id);
  }
}
