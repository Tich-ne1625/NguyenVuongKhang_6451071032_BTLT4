class SurveyModel {
  final List<String> hobbies;
  final String satisfactionLevel;
  final String note;

  SurveyModel({
    required this.hobbies,
    required this.satisfactionLevel,
    required this.note,
  });

  @override
  String toString() {
    return 'SurveyModel{hobbies: $hobbies, satisfactionLevel: $satisfactionLevel, note: $note}';
  }
}
