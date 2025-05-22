import 'package:get_it/get_it.dart';
import 'package:mybudget/core/network/api_client.dart';
import 'package:mybudget/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mybudget/features/auth/domain/repositories/auth_repository.dart';
import 'package:mybudget/features/auth/domain/usecases/get_user.dart';
import 'package:mybudget/features/auth/domain/usecases/login.dart';
import 'package:mybudget/features/auth/domain/usecases/register.dart';
import 'package:mybudget/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:mybudget/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:mybudget/features/onboarding/domain/usecases/check_onboarding_status.dart';
import 'package:mybudget/features/onboarding/domain/usecases/complete_onboarding.dart';

part 'injection_container.main.dart';
