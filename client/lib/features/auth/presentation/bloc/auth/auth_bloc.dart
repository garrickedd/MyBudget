import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/services/auth_service.dart';
import 'package:my_budget/features/auth/domain/usecases/auth/login.dart';
import 'package:my_budget/features/auth/domain/usecases/auth/register.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Register register;
  final AuthService authService;

  AuthBloc(this.login, this.register, this.authService) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (!_validateEmail(event.email) || event.password.isEmpty) {
      emit(AuthFailure('Please enter a valid email and password'));
      return;
    }

    emit(AuthLoading());
    final result = await login(
      LoginParams(email: event.email, password: event.password),
    );
    emit(
      result.fold((failure) => AuthFailure(failure.message), (response) {
        authService.saveToken(response.token);
        return AuthSuccess(token: response.token);
      }),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (!_validateEmail(event.email) ||
        event.password.length < 6 ||
        event.name.isEmpty) {
      emit(
        AuthFailure(
          'Please enter a valid email, name, and password (min 6 characters)',
        ),
      );
      return;
    }

    emit(AuthLoading());
    final result = await register(
      RegisterParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );
    emit(
      result.fold(
        (failure) => AuthFailure(failure.message),
        (_) => AuthSuccess(),
      ),
    );
  }

  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
