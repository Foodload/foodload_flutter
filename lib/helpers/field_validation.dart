class FieldValidation {
  static const MAX_AMOUNT = 999;

  static bool isInteger(String num) {
    if (num == null) return false;

    final res = int.tryParse(num);
    if (res == null) return false;

    return true;
  }

  static bool isAmountOverflow(int amount) {
    return amount > MAX_AMOUNT;
  }

  static bool isNotEmpty(String input) {
    return input != null && input.isNotEmpty;
  }
}
