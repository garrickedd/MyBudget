import 'package:mybudget/features/home/data/datasources/home_remote_datasource.dart';
import 'package:mybudget/features/home/domain/entities/financial_summary.dart';
import 'package:mybudget/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<FinancialSummary> getFinancialSummary(String userId) {
    return remoteDataSource.getFinancialSummary(userId);
  }
}
