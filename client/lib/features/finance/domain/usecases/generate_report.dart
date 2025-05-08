import 'package:dartz/dartz.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/core/usecases/usecase.dart';
import 'package:my_budget/features/finance/domain/entities/report_entity.dart';
import 'package:my_budget/features/finance/domain/repositories/finance_repository.dart';

class GenerateReport implements UseCase<Report, GenerateReportParams> {
  final FinanceRepository repository;

  GenerateReport(this.repository);

  @override
  Future<Either<Failure, Report>> call(GenerateReportParams params) async {
    return await repository.generateReport(params.userId, params.month);
  }
}

class GenerateReportParams {
  final String userId;
  final String month;

  GenerateReportParams({required this.userId, required this.month});
}
