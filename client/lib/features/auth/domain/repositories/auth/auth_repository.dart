import 'package:dartz/dartz.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/auth/domain/entities/auth/auth_response_entity.dart';
import 'package:my_budget/features/auth/domain/entities/auth/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, AuthResponseEntity>> login({
    required String email,
    required String password,
  });
}
