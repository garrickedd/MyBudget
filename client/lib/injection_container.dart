import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:my_budget/features/finance/data/datasources/finance_remote_datasource.dart';
import 'package:my_budget/features/finance/data/repositories/finance_repository_impl.dart';
import 'package:my_budget/features/finance/domain/repositories/finance_repository.dart';
import 'package:my_budget/features/finance/domain/usecases/create_budget.dart';
import 'package:my_budget/features/finance/domain/usecases/generate_report.dart';
import 'package:my_budget/features/finance/domain/usecases/get_budgets.dart';
import 'package:my_budget/features/finance/domain/usecases/get_jars.dart';
import 'package:my_budget/features/finance/domain/usecases/get_transactions.dart';
import 'package:my_budget/features/finance/domain/usecases/record_expense.dart';
import 'package:my_budget/features/finance/domain/usecases/record_income.dart';
import 'package:my_budget/features/finance/presentation/bloc/finance_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'http://localhost:8080', // Adjust to your backend URL
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    ),
  );

  // Data sources
  sl.registerLazySingleton<FinanceRemoteDataSource>(
    () => FinanceRemoteDataSourceImpl(sl<Dio>()),
  );

  // Repositories
  sl.registerLazySingleton<FinanceRepository>(
    () => FinanceRepositoryImpl(sl<FinanceRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetJars(sl<FinanceRepository>()));
  sl.registerLazySingleton(() => RecordIncome(sl<FinanceRepository>()));
  sl.registerLazySingleton(() => RecordExpense(sl<FinanceRepository>()));
  sl.registerLazySingleton(() => GetTransactions(sl<FinanceRepository>()));
  sl.registerLazySingleton(() => CreateBudget(sl<FinanceRepository>()));
  sl.registerLazySingleton(() => GetBudgets(sl<FinanceRepository>()));
  sl.registerLazySingleton(() => GenerateReport(sl<FinanceRepository>()));

  // BLoC
  sl.registerFactory<FinanceBloc>(
    () => FinanceBloc(
      sl<GetJars>(),
      sl<RecordIncome>(),
      sl<RecordExpense>(),
      sl<GetTransactions>(),
      sl<CreateBudget>(),
      sl<GetBudgets>(),
      sl<GenerateReport>(),
    ),
  );
}
