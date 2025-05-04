import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:my_budget/core/services/auth_service.dart';
import 'package:my_budget/features/auth/data/datasources/auth/auth_remote_datasource.dart';
import 'package:my_budget/features/auth/data/datasources/onboarding/onboarding_local_datasource.dart';
import 'package:my_budget/features/auth/data/repositories/auth/auth_repository_impl.dart';
import 'package:my_budget/features/auth/data/repositories/onboarding/onboarding_repository_impl.dart';
import 'package:my_budget/features/auth/domain/repositories/auth/auth_repository.dart';
import 'package:my_budget/features/auth/domain/repositories/onboarding/onboarding_repository.dart';
import 'package:my_budget/features/auth/domain/usecases/auth/login.dart';
import 'package:my_budget/features/auth/domain/usecases/auth/register.dart';
import 'package:my_budget/features/auth/domain/usecases/onboarding/get_onboarding_content.dart';
import 'package:my_budget/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:my_budget/features/auth/presentation/bloc/onboarding/onboarding_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );

  // Services
  sl.registerLazySingleton<AuthService>(() => AuthService());

  // Bloc
  sl.registerFactory(() => OnboardingBloc(sl(), sl()));
  sl.registerFactory(() => AuthBloc(sl(), sl(), sl()));

  // Use cases
  sl.registerLazySingleton(() => GetOnboardingContent(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Register(sl()));

  // Repository
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
}
