import 'dart:convert';
import 'dart:io';

import 'package:foodload_flutter/helpers/error_handler/core/error_handler.dart';
import 'package:foodload_flutter/helpers/error_handler/model/exceptions.dart'
    as ErrorHandlerExceptions;
import 'package:foodload_flutter/helpers/keys.dart';
import 'package:foodload_flutter/models/enums/http_method.dart';
import 'package:foodload_flutter/models/exceptions/api_exception.dart';
import 'package:foodload_flutter/models/exceptions/api_exception_response.dart';
import 'package:http/http.dart' as http;

class FoodloadApiClient {
  final _helper = _ApiBaseHelper(http.Client());

  Future<dynamic> sendInit(String token) async {
    const urlSegment = 'init';
    return await _helper.get(urlSegment, token);
  }

  Future<void> addItemQR(
      {String qr, int amount, String storageType, String token}) async {
    const urlSegment = 'add-item';
    Map<String, dynamic> body = {
      'qrCode': qr,
      'amount': amount,
      'storageType': storageType,
    };
    final resp = await _helper.post(urlSegment, token, body);
    print(resp);
  }

  Future<dynamic> getItemCounts(String token) async {
    const urlSegment = 'get-all-item-counts';
    return await _helper.get(urlSegment, token);
  }

  Future<void> incrementItem(String token, int id) async {
    const urlSegment = 'increment-item';
    Map<String, dynamic> body = {
      'id': id,
    };
    await _helper.post(
      urlSegment,
      token,
      body,
    );
  }

  Future<void> decrementItem(String token, int id) async {
    const urlSegment = 'decrement-item';
    Map<String, dynamic> body = {
      'id': id,
    };
    await _helper.post(
      urlSegment,
      token,
      body,
    );
  }

  Future<dynamic> findItemByName(
      String searchText, int startIndex, String token) async {
    const urlSegment = 'find-item-by-name';
    Map<String, dynamic> body = {
      'name': searchText,
      'start': startIndex,
    };

    return await _helper.post(
      urlSegment,
      token,
      body,
    );
  }

  Future<dynamic> findItemByQr(String qr, String token) async {
    const urlSegment = 'search-item';
    Map<String, dynamic> body = {
      'qrCode': qr,
    };
    return await _helper.post(
      urlSegment,
      token,
      body,
    );
  }

  Future<dynamic> moveItemToStorage({
    String token,
    int id,
    String storageType,
    int oldAmount,
    int moveAmount,
  }) async {
    const urlSegment = 'move-item-to';
    Map<String, dynamic> body = {
      'itemCountId': id,
      'storageType': storageType,
      'moveAmount': moveAmount,
      'oldAmount': oldAmount,
    };
    return await _helper.post(urlSegment, token, body);
  }

  Future<dynamic> moveItemFromStorage(
      {String token,
      int id,
      String storageType,
      int oldAmount,
      int moveAmount}) async {
    const urlSegment = 'move-item-from';
    Map<String, dynamic> body = {
      'itemCountId': id,
      'storageType': storageType,
      'moveAmount': moveAmount,
      'oldAmount': oldAmount,
    };
    return await _helper.post(
      urlSegment,
      token,
      body,
    );
  }

  Future<void> deleteItem({String token, int id, int amount}) async {
    const urlSegment = 'delete-item';
    Map<String, dynamic> body = {
      'itemCountId': id,
      'amount': amount,
    };
    final resp = await _helper.post(
      urlSegment,
      token,
      body,
    );
    print(resp);
  }

  Future<dynamic> updateItemAmount(
      {String token, int id, int newAmount, int oldAmount}) async {
    const urlSegment = 'change-item-count';
    Map<String, dynamic> body = {
      'itemCountId': id,
      'amount': oldAmount,
      'newAmount': newAmount,
    };
    return await _helper.post(
      urlSegment,
      token,
      body,
    );
  }

  Future<dynamic> getTemplates(String token) async {
    const urlSegment = 'get-templates';
    return await _helper.get(urlSegment, token);
  }

  Future<dynamic> createTemplate(
      String token, Map<String, dynamic> body) async {
    const urlSegment = 'create-template';
    return await _helper.post(urlSegment, token, body);
  }

  Future<dynamic> addTemplateItemToTemplate(
      String token, int templateId, int itemId, int amount) async {
    final urlSegment = 'add-template-item/$templateId';
    final Map<String, dynamic> body = {
      "itemId": itemId,
      "count": amount,
    };
    return await _helper.post(urlSegment, token, body);
  }

  Future<void> updateTemplateItem(
      {String token, int templateId, int templateItemId, int newAmount}) async {
    const urlSegment = 'update-template-item';
    final Map<String, dynamic> body = {
      "templateId": templateId, //check
      "templateItemId": templateItemId, //check
      "count": newAmount,
    };
    await _helper.put(urlSegment, token, body);
  }

  Future<dynamic> removeTemplateItem(
      String token, int templateId, int templateItemId) async {
    final urlSegment =
        'remove-template-item?templateId=$templateId&templateItemId=$templateItemId';
    return await _helper.delete(urlSegment, token);
  }

  Future<void> deleteTemplate(String token, int templateId) async {
    final urlSegment = 'delete-template/$templateId';
    await _helper.delete(urlSegment, token);
  }

  Future<dynamic> getBuyList(String token, int templateId) async {
    final urlSegment = "buy-list/$templateId";
    return await _helper.get(urlSegment, token);
  }
}

class _ApiBaseHelper {
  final http.Client _client;
  final String _baseUrl = backendURL;

  _ApiBaseHelper(http.Client client)
      : assert(client != null),
        _client = client;

  Map<String, String> _headers(String token) {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    return headers;
  }

  Future<dynamic> delete(String urlSegment, String token) async {
    return await _sendRequest(urlSegment, token, HttpMethod.DELETE);
  }

  Future<dynamic> put(
      String urlSegment, String token, Map<String, dynamic> body) async {
    return await _sendRequest(urlSegment, token, HttpMethod.PUT, body: body);
  }

  Future<dynamic> get(String urlSegment, String token) async {
    return await _sendRequest(urlSegment, token, HttpMethod.GET);
    /*
    var responseJson;
    try {
      final response =
          await _client.get(_baseUrl + urlSegment, headers: _headers(token));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw NoInternetException("No Internet connection. Try again later.");
    }
    return responseJson;
     */
  }

  Future<dynamic> post(
      String urlSegment, String token, Map<String, dynamic> body) async {
    return await _sendRequest(urlSegment, token, HttpMethod.POST, body: body);
    /*
    var responseJson;
    try {
      final response = await _client.post(_baseUrl + urlSegment,
          headers: _headers(token), body: json.encode(body));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw NoInternetException("No Internet connection. Try again later.");
    }
    return responseJson;
       */
  }

  Future<dynamic> _sendRequest(
      String urlSegment, String token, HttpMethod method,
      {Map<String, dynamic> body}) async {
    var response;
    try {
      switch (method) {
        case HttpMethod.POST:
          response = await _client.post(_baseUrl + urlSegment,
              headers: _headers(token), body: json.encode(body));
          break;
        case HttpMethod.GET:
          response = await _client.get(_baseUrl + urlSegment,
              headers: _headers(token));
          break;
        case HttpMethod.DELETE:
          response = await _client.delete(_baseUrl + urlSegment,
              headers: _headers(token));
          break;
        case HttpMethod.PUT:
          response = await _client.put(_baseUrl + urlSegment,
              headers: _headers(token), body: json.encode(body));
          break;
        default:
          throw Exception("Not supported HTTP Method");
      }
    } on SocketException {
      throw NoInternetException("No Internet connection. Try again later.");
    }
    return _returnResponse(response);
  }

  dynamic _returnResponse(http.Response response) {
    var responseJsonBody;
    if (_hasBody(response)) {
      try {
        responseJsonBody = _getDecodedBody(response);
      } on FormatException catch (error, stackTrace) {
        ErrorHandler.reportCheckedError(
            ErrorHandlerExceptions.ComponentLogException(error.message),
            stackTrace);
        throw BadFormatException('Bad format sent from server.');
      }
    }
    switch (response.statusCode) {
      case 200:
        return responseJsonBody;
      case 400:
        throw BadRequestException(ApiExceptionResponse(responseJsonBody));
      case 401:
      case 403:
        throw UnauthorizedException(ApiExceptionResponse(responseJsonBody));
      case 404:
        throw NotFoundException(ApiExceptionResponse(responseJsonBody));
      case 409:
        throw ConflictException(ApiExceptionResponse(responseJsonBody));
      case 500:
        throw FetchDataException('Server failed. Please try again later.');
      default:
        throw FetchDataException(
            'Communication failed. Please try again later.');
    }
  }

  bool _hasBody(http.Response response) =>
      response.body != null && response.body.isNotEmpty;

  dynamic _getDecodedBody(http.Response response) => json.decode(response.body);
}
