class Validators {
  static String? validateHobbies(List<String> hobbies) {
    if (hobbies.isEmpty) {
      return 'Vui lòng chọn ít nhất 1 sở thích';
    }
    return null;
  }

  static String? validateSatisfaction(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng chọn mức độ hài lòng';
    }
    return null;
  }
}
