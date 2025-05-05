// model to map onboarding data

import 'package:my_budget/features/onboarding/domain/entities/onboarding_entitiy.dart';

class OnboardingModel extends OnboardingEntitiy {
  OnboardingModel({
    required String title,
    required String description,
    required String imageUrl,
  }) : super(title: title, description: description, imageUrl: imageUrl);

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'imageUrl': imageUrl};
  }
}
