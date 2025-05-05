import 'package:dartz/dartz.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_budget/features/auth/domain/entities/auth_response_entity.dart';
import 'package:my_budget/features/auth/domain/entities/user_entity.dart';
import 'package:my_budget/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );
      return Right(user);
    } catch (e) {
      return Left(e is AuthFailure ? e : ServerFailure());
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(response);
    } catch (e) {
      return Left(e is AuthFailure ? e : ServerFailure());
    }
  }
}
