class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tên không được để trống';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tuổi không được để trống';
    }
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Tuổi phải là số nguyên';
    }
    if (age <= 0) {
      return 'Tuổi phải lớn hơn 0';
    }
    if (age > 150) {
      return 'Tuổi không hợp lệ';
    }
    return null;
  }
}
