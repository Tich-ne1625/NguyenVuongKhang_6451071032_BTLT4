class PersonalInfoModel {
  final String name;
  final int age;
  final String gender;
  final String maritalStatus;
  final double incomeLevel;

  PersonalInfoModel({
    required this.name,
    required this.age,
    required this.gender,
    required this.maritalStatus,
    required this.incomeLevel,
  });

  @override
  String toString() {
    return 'PersonalInfoModel{name: $name, age: $age, gender: $gender, '
        'maritalStatus: $maritalStatus, incomeLevel: $incomeLevel}';
  }
}
