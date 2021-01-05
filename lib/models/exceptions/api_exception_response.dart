class ApiExceptionResponse {
  String message;
  final Map<String, dynamic> body;

  ApiExceptionResponse(this.body) {
    if (body != null) {
      message = body['message'];
    }
  }
}
