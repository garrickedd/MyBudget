class OnboardingModel {
  final String image;
  final String title;
  final String description;
  final String? footer;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
    this.footer,
  });
}
