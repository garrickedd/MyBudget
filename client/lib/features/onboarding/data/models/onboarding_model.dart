import 'package:equatable/equatable.dart';
import 'package:mybudget/features/onboarding/domain/entities/onboarding_page.dart';

class OnboardingModel extends Equatable {
  final String title;
  final String description;
  final String image;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
  });

  factory OnboardingModel.fromEntity(OnboardingPage page) {
    return OnboardingModel(
      title: page.title,
      description: page.description,
      image: page.image,
    );
  }

  OnboardingPage toEntity() {
    return OnboardingPage(title: title, description: description, image: image);
  }

  @override
  List<Object> get props => [title, description, image];
}
