class InternalServerErrorException implements Exception {
  final String message;
  const InternalServerErrorException(this.message);

  @override
  String toString() {
    return message;
  }
}
