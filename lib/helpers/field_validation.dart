class FieldValidation {
  //TODO: Use this in other place as well...
  static bool isInteger(String num) {
    if (num == null) return false;

    final res = int.tryParse(num);
    if (res == null) return false;

    return true;
  }
}
