class ApiException implements Exception {
  final _message;
  final _prefix;

  const ApiException([this._message, this._prefix]);

  @override
  String toString() {
    return '$_prefix: $_message';
  }

  String getMessage() {
    return _message;
  }

  String getPrefix() {
    return _prefix;
  }
}

class FetchDataException extends ApiException {
  const FetchDataException([String message])
      : super(message, 'Communication Failed');
}

class BadRequestException extends ApiException {
  const BadRequestException([String message])
      : super(message, 'Invalid Request');
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException([String message])
      : super(message, 'Unauthorized');
}

class InvalidInputException extends ApiException {
  const InvalidInputException([String message])
      : super(message, 'Invalid Input');
}

class ConflictException extends ApiException {
  const ConflictException([String message]) : super(message, 'Conflict');
}

class NotFoundException extends ApiException {
  const NotFoundException([String message]) : super(message, 'Not Found');
}

class NoInternetException extends ApiException {
  const NoInternetException([String message]) : super(message, 'No Internet');
}
