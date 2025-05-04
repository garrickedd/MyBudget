import 'package:dartz/dartz.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/core/usecases/usecase.dart';
import 'package:my_budget/features/auth/domain/entities/auth/auth_response_entity.dart';
import 'package:my_budget/features/auth/domain/repositories/auth/auth_repository.dart';

class Login implements UseCase<AuthResponseEntity, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, AuthResponseEntity>> call(LoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
