abstract class OnboardingEvent {}

class FetchOnboardingContent extends OnboardingEvent {}

class UpdatePageIndex extends OnboardingEvent {
  final int index;

  UpdatePageIndex(this.index);
}

class SkipOnboarding extends OnboardingEvent {}

class CompleteOnboarding extends OnboardingEvent {}
