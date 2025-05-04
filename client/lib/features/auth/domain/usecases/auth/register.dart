import 'package:dartz/dartz.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/core/usecases/usecase.dart';
import 'package:my_budget/features/auth/domain/entities/auth/user_entity.dart';
import 'package:my_budget/features/auth/domain/repositories/auth/auth_repository.dart';

class Register implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  Register(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}

class RegisterParams {
  final String email;
  final String password;
  final String name;

  RegisterParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
