part of 'injection_container.dart';

final GetIt getIt = GetIt.instance;

void initDependencies() {
  // API Client
  getIt.registerSingleton<ApiClient>(ApiClient());

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(getIt<ApiClient>()),
  );
  getIt.registerSingleton<OnboardingRepository>(OnboardingRepositoryImpl());

  // Use Cases
  getIt.registerSingleton<Register>(Register(getIt<AuthRepository>()));
  getIt.registerSingleton<Login>(Login(getIt<AuthRepository>()));
  getIt.registerSingleton<GetUser>(GetUser(getIt<AuthRepository>()));
  getIt.registerSingleton<CheckOnboardingStatus>(
    CheckOnboardingStatus(getIt<OnboardingRepository>()),
  );
  getIt.registerSingleton<CompleteOnboarding>(
    CompleteOnboarding(getIt<OnboardingRepository>()),
  );
}
