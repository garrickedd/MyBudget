import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mybudget/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mybudget/core/network/api_client.dart';
import 'package:mybudget/core/network/network_info.dart';
import 'package:mybudget/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:mybudget/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:mybudget/features/onboarding/presentation/providers/onboarding_provider.dart';
// import 'package:mybudget/features/auth/data/datasources/auth_local_datasource.dart';
// import 'package:mybudget/features/auth/data/repositories/auth_repository_impl.dart';
// import 'package:mybudget/features/auth/domain/repositories/auth_repository.dart';
// import 'package:mybudget/features/auth/domain/usecases/login.dart';
// import 'package:mybudget/features/auth/domain/usecases/register.dart';
// import 'package:mybudget/features/auth/presentation/providers/auth_provider.dart';

part 'injection_container.main.dart';
