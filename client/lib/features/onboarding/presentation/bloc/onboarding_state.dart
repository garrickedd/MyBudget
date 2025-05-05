import 'package:my_budget/features/onboarding/domain/entities/onboarding_entitiy.dart';

abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final List<OnboardingEntitiy> contents;
  final int currentPage;

  OnboardingLoaded(this.contents, {this.currentPage = 0});
}

class OnboardingError extends OnboardingState {
  final String message;

  OnboardingError(this.message);
}

class OnboardingCompleted extends OnboardingState {}
