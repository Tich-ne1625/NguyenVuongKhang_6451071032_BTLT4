class UserModel {
  final String fullName;
  final String email;
  final String password;
  final bool agreedToTerms;

  UserModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.agreedToTerms,
  });

  @override
  String toString() {
    return 'UserModel{fullName: $fullName, email: $email, agreedToTerms: $agreedToTerms}';
  }
}
