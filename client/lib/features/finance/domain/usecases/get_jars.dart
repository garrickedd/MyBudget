import 'package:dartz/dartz.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/core/usecases/usecase.dart';
import 'package:my_budget/features/finance/domain/entities/jar_entity.dart';
import 'package:my_budget/features/finance/domain/repositories/finance_repository.dart';

class GetJars implements UseCase<List<Jar>, String> {
  final FinanceRepository repository;

  GetJars(this.repository);

  @override
  Future<Either<Failure, List<Jar>>> call(String userId) async {
    return await repository.getJars(userId);
  }
}
