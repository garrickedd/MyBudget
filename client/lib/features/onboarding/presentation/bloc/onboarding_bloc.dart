import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/services/auth_service.dart';
import 'package:my_budget/core/usecases/usecase.dart';
import 'package:my_budget/features/onboarding/domain/usecases/get_onboarding_content.dart';
import 'package:my_budget/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:my_budget/features/onboarding/presentation/bloc/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetOnboardingContent getOnboardingContent;
  final AuthService authService;

  OnboardingBloc(this.getOnboardingContent, this.authService)
    : super(OnboardingInitial()) {
    on<FetchOnboardingContent>(_onFetchOnboardingContent);
    on<UpdatePageIndex>(_onUpdatePageIndex);
    on<SkipOnboarding>(_onSkipOnboarding);
    on<CompleteOnboarding>(_onCompleteOnboarding);
  }

  Future<void> _onFetchOnboardingContent(
    FetchOnboardingContent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());
    final result = await getOnboardingContent(NoParams());
    emit(
      result.fold(
        (failure) => OnboardingError(failure.message),
        (contents) => OnboardingLoaded(contents),
      ),
    );
  }

  void _onUpdatePageIndex(
    UpdatePageIndex event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingLoaded) {
      final currentState = state as OnboardingLoaded;
      emit(OnboardingLoaded(currentState.contents, currentPage: event.index));
    }
  }

  Future<void> _onSkipOnboarding(
    SkipOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    await authService.setOnBoardingCompleted();
    emit(OnboardingCompleted());
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    await authService.setOnBoardingCompleted();
    emit(OnboardingCompleted());
  }
}
