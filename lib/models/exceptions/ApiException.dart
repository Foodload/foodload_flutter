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
  BadRequestException([Map<String, dynamic> body])
      : super(body['message'], 'Invalid Request');
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([Map<String, dynamic> body])
      : super(body['message'], 'Unauthorized');
}

class InvalidInputException extends ApiException {
  InvalidInputException([Map<String, dynamic> body])
      : super(body['message'], 'Invalid Input');
}

class ConflictException extends ApiException {
  ConflictException([Map<String, dynamic> body])
      : super(body['message'], 'Conflict');
}

class NotFoundException extends ApiException {
  NotFoundException([Map<String, dynamic> body])
      : super(body['message'], 'Not Found');
}

class NoInternetException extends ApiException {
  NoInternetException([String message]) : super(message, 'No Internet');
}
