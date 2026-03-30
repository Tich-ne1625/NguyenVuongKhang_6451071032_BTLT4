class MultiStepModel {
  // Step 1: Personal info
  String fullName;
  String email;
  String phone;

  // Step 2: Interests + slider
  List<String> interests;
  double budget;

  MultiStepModel({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.interests = const [],
    this.budget = 5.0,
  });

  MultiStepModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    List<String>? interests,
    double? budget,
  }) {
    return MultiStepModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      interests: interests ?? this.interests,
      budget: budget ?? this.budget,
    );
  }
}
