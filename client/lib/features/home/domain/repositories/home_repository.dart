import 'package:mybudget/features/home/domain/entities/financial_summary.dart';

abstract class HomeRepository {
  Future<FinancialSummary> getFinancialSummary(String userId);
}
