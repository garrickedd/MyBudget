part of 'injection_container.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Core dependencies
  getIt.registerSingleton<ApiClient>(ApiClient());

  // Auth feature
  // - Repository: Handles authentication-related data operations
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(getIt<ApiClient>()),
  );
  // - Use Cases: Business logic for authentication
  getIt.registerSingleton<Register>(Register(getIt<AuthRepository>()));
  getIt.registerSingleton<Login>(Login(getIt<AuthRepository>()));
  getIt.registerSingleton<GetUser>(GetUser(getIt<AuthRepository>()));
  // - Provider: Manages auth state and exposes it to the UI
  getIt.registerSingleton<AuthProvider>(
    AuthProvider(
      register: getIt<Register>(),
      login: getIt<Login>(),
      getUser: getIt<GetUser>(),
    ),
  );

  // Onboarding feature
  // - Repository: Manages onboarding state (e.g., first launch status)
  getIt.registerSingleton<OnboardingRepository>(OnboardingRepositoryImpl());
  // - Use Cases: Business logic for onboarding
  getIt.registerSingleton<CheckOnboardingStatus>(
    CheckOnboardingStatus(getIt<OnboardingRepository>()),
  );
  getIt.registerSingleton<CompleteOnboarding>(
    CompleteOnboarding(getIt<OnboardingRepository>()),
  );
  // - Provider: Manages onboarding state and exposes it to the UI
  getIt.registerSingleton<OnboardingProvider>(
    OnboardingProvider(
      checkOnboardingStatus: getIt<CheckOnboardingStatus>(),
      completeOnboarding: getIt<CompleteOnboarding>(),
      repository: getIt<OnboardingRepository>(),
    ),
  );

  // Jars feature
  // - Data Source: Handles API calls for jars
  getIt.registerLazySingleton<JarRemoteDataSource>(
    () => JarRemoteDataSource(getIt<ApiClient>()),
  );
  // - Repository: Manages jar-related data operations
  getIt.registerLazySingleton<JarRepository>(
    () => JarRepositoryImpl(getIt<JarRemoteDataSource>()),
  );
  // - Use Cases: Business logic for jars
  getIt.registerLazySingleton<GetUserJars>(
    () => GetUserJars(getIt<JarRepository>()),
  );
  getIt.registerLazySingleton<UpdateJarPercentage>(
    () => UpdateJarPercentage(getIt<JarRepository>()),
  );
  // - Provider: Manages jar state and exposes it to the UI
  getIt.registerSingleton<JarsProvider>(
    JarsProvider(getIt<JarRemoteDataSource>()),
  );

  // Home feature
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
  );
  getIt.registerSingleton<GetFinancialSummary>(
    GetFinancialSummary(getIt<HomeRepository>()),
  );
  getIt.registerSingleton<HomeProvider>(
    HomeProvider(getFinancialSummary: getIt<GetFinancialSummary>()),
  );

  // Transactions feature
  getIt.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSource(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(getIt<TransactionRemoteDataSource>()),
  );
  getIt.registerSingleton<CreateTransaction>(
    CreateTransaction(getIt<TransactionRepository>()),
  );
  getIt.registerSingleton<TransactionProvider>(
    TransactionProvider(createTransaction: getIt<CreateTransaction>()),
  );
}
