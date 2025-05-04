import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/features/auth/presentation/bloc/onboarding/onboarding_bloc.dart';
import 'package:my_budget/features/auth/presentation/bloc/onboarding/onboarding_event.dart';
import 'package:my_budget/features/auth/presentation/bloc/onboarding/onboarding_state.dart';
import 'package:my_budget/features/auth/presentation/widget/onboarding/onboarding_content_widget.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              OnboardingBloc(context.read(), context.read())
                ..add(FetchOnboardingContent()),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    return Scaffold(
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is OnboardingError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is OnboardingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OnboardingLoaded) {
            return Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: state.contents.length,
                  onPageChanged: (index) {
                    context.read<OnboardingBloc>().add(UpdatePageIndex(index));
                  },
                  itemBuilder: (context, index) {
                    return OnboardingContentWidget(
                      content: state.contents[index],
                    );
                  },
                ),
                Positioned(
                  child: TextButton(
                    onPressed: () {
                      context.read<OnboardingBloc>().add(SkipOnboarding());
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 32,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(
                          state.contents.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  state.currentPage == index
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (state.currentPage == state.contents.length - 1) {
                            context.read<OnboardingBloc>().add(
                              CompleteOnboarding(),
                            );
                          } else {
                            pageController.nextPage(
                              duration: const Duration(microseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          state.currentPage == state.contents.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
