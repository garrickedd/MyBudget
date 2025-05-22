part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External packages
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());

  // InternetConnectionChecker với cấu hình mặc định
  sl.registerLazySingleton(
    () => InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 5), // Timeout cho mỗi lần kiểm tra
      checkInterval: const Duration(
        seconds: 10,
      ), // Khoảng thời gian giữa các lần kiểm tra
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(
    () => ApiClient(client: sl(), baseUrl: 'http://localhost:8080/api/v1'),
  );

  // Onboarding Feature
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(localDataSource: sl()),
  );

  sl.registerFactory(() => OnboardingProvider(repository: sl()));

  // Auth Feature
  // sl.registerLazySingleton<AuthLocalDataSource>(
  //   () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  // );

  // sl.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(localDataSource: sl(), networkInfo: sl()),
  // );

  // sl.registerLazySingleton(() => Login(repository: sl()));
  // sl.registerLazySingleton(() => Register(repository: sl()));

  // sl.registerFactory(
  //   () => AuthProvider(login: sl(), register: sl(), localDataSource: sl()),
  // );
}
