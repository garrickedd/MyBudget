import 'package:mybudget/features/home/domain/entities/financial_summary.dart';
import 'package:mybudget/features/home/domain/repositories/home_repository.dart';

class GetFinancialSummary {
  final HomeRepository repository;

  GetFinancialSummary(this.repository);

  Future<FinancialSummary> call(String userId) {
    return repository.getFinancialSummary(userId);
  }
}
