import 'package:foodload_flutter/models/exceptions/api_exception_response.dart';

class ApiException implements Exception {
  final String _message;
  final String _prefix;
  final ApiExceptionResponse _apiExceptionResponse;

  const ApiException([this._message, this._prefix, this._apiExceptionResponse]);

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

  ApiExceptionResponse getApiExceptionResponse() {
    return _apiExceptionResponse;
  }
}

class FetchDataException extends ApiException {
  const FetchDataException([String message])
      : super(message, 'Communication Failed');
}

class BadRequestException extends ApiException {
  BadRequestException(ApiExceptionResponse apiExceptionResponse)
      : super(
            apiExceptionResponse.message, 'Bad Request', apiExceptionResponse);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(ApiExceptionResponse apiExceptionResponse)
      : super(
            apiExceptionResponse.message, 'Unauthorized', apiExceptionResponse);
}

class InvalidInputException extends ApiException {
  InvalidInputException(ApiExceptionResponse apiExceptionResponse)
      : super(apiExceptionResponse.message, 'Invalid Input',
            apiExceptionResponse);
}

class ConflictException extends ApiException {
  ConflictException(ApiExceptionResponse apiExceptionResponse)
      : super(apiExceptionResponse.message, 'Conflict', apiExceptionResponse);
}

class NotFoundException extends ApiException {
  NotFoundException(ApiExceptionResponse apiExceptionResponse)
      : super(apiExceptionResponse.message, 'Not Found', apiExceptionResponse);
}

class NoInternetException extends ApiException {
  NoInternetException([String message]) : super(message, 'No Internet');
}

class BadFormatException extends ApiException {
  const BadFormatException([String message]) : super(message, 'Bad Format');
}
