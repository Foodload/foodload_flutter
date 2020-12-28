class FieldValidation {
  static bool isInteger(String num) {
    if (num == null) return false;

    final res = int.tryParse(num);
    if (res == null) return false;

    return true;
  }

  static bool isAmountOverflow(int amount) {
    return amount > 999;
  }

  static bool isNotEmpty(String input) {
    return input != null && input.isNotEmpty;
  }
}
