import 'package:dartz/dartz.dart';
import 'package:mybudget/core/errors/failures.dart';
import 'package:mybudget/core/errors/exceptions.dart';

Either<Failure, T> handleError<T>(dynamic error) {
  if (error is NetworkException) {
    return Left(NetworkFailure());
  } else if (error is UnauthorizedException) {
    return Left(UnauthorizedFailure());
  } else if (error is BadRequestException) {
    return Left(ValidationFailure(error.message));
  } else if (error is NotFoundException) {
    return Left(ValidationFailure(error.message));
  } else if (error is ServerException) {
    return Left(ServerFailure());
  } else if (error is CacheException) {
    return Left(CacheFailure());
  } else {
    return Left(ServerFailure());
  }
}
