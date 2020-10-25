class BadResponseException implements Exception {
  final String message;
  const BadResponseException(this.message);

  @override
  String toString() {
    return message;
  }
}
