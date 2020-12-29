import 'dart:convert';
import 'dart:io';

import 'package:foodload_flutter/helpers/keys.dart';
import 'package:foodload_flutter/models/exceptions/ApiException.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/models/item_info.dart';
import 'package:foodload_flutter/models/item_updated_info.dart';
import 'package:foodload_flutter/models/user.dart';
import 'package:http/http.dart' as http;

class FoodloadApiClient {
  final _helper = _ApiBaseHelper(http.Client());

  Future<User> sendInit(String token) async {
    const urlSegment = 'login';
    final resp = await _helper.get(urlSegment, token);
    final user = User(
      token: resp['token'],
      email: resp['client']['email'],
      familyId: resp['client']['family']['id'],
      familyName: resp['client']['family']['name'],
    );
    return user;
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

  Future<String> removeItemQR(
      String token, String qr, String storageType) async {
    const urlSegment = 'removeItemQR';
    Map<String, dynamic> body = {
      'qrCode': qr,
      'amount': "1",
      'storageType': storageType,
    };
    final resp = await _helper.post(urlSegment, token, body);
    print(resp);
    return resp.body;
  }

  Future<List<Item>> getItemCounts(String token) async {
    const urlSegment = 'get-all-item-counts';
    final resp = await _helper.get(urlSegment, token);
    List<Item> fridgeItems =
        (resp as List).map((jsonItem) => Item.fromJson(jsonItem)).toList();
    return fridgeItems;
  }

  Future<void> incrementItem(String token, int id) async {
    const urlSegment = 'increment-item';
    Map<String, dynamic> body = {
      'id': id,
    };
    final resp = await _helper.post(
      urlSegment,
      token,
      body,
    );
    print(resp);
  }

  Future<void> decrementItem(String token, int id) async {
    const urlSegment = 'decrement-item';
    Map<String, dynamic> body = {
      'id': id,
    };
    final resp = await _helper.post(
      urlSegment,
      token,
      body,
    );
    print(resp);
  }

  Future<List<ItemInfo>> findItemByName(
      String searchText, int startIndex, String token) async {
    const urlSegment = 'find-item-by-name';
    Map<String, dynamic> body = {
      'name': searchText,
      'start': startIndex,
    };

    final resp = await _helper.post(
      urlSegment,
      token,
      body,
    );
    List<ItemInfo> results =
        (resp as List).map((jsonItem) => ItemInfo.fromJson(jsonItem)).toList();
    return results;
  }

  Future<ItemInfo> findItemByQr(String qr, String token) async {
    const urlSegment = 'search-item';
    Map<String, dynamic> body = {
      'qrCode': qr,
    };
    final resp = await _helper.post(
      urlSegment,
      token,
      body,
    );
    final itemInfo = ItemInfo.fromJson(resp);
    return itemInfo;
  }

  Future<ItemUpdatedInfo> moveItemToStorage({
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
    final resp = await _helper.post(urlSegment, token, body);
    return ItemUpdatedInfo.fromJson(resp);
  }

  Future<ItemUpdatedInfo> moveItemFromStorage(
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
    final resp = await _helper.post(
      urlSegment,
      token,
      body,
    );
    return ItemUpdatedInfo.fromJson(resp);
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

  Future<ItemUpdatedInfo> updateItemAmount(
      {String token, int id, int newAmount, int oldAmount}) async {
    const urlSegment = 'change-item-count';
    Map<String, dynamic> body = {
      'itemCountId': id,
      'amount': oldAmount,
      'newAmount': newAmount,
    };
    final resp = await _helper.post(
      urlSegment,
      token,
      body,
    );
    return ItemUpdatedInfo.fromJson(resp);
  }

  Future<String> requestFamilyToken(String userToken) async {
    //const urlSegment = ''
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

  Future<dynamic> get(String urlSegment, String token) async {
    var responseJson;
    try {
      final response =
          await _client.get(_baseUrl + urlSegment, headers: _headers(token));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw NoInternetException("No Internet connection. Try again later.");
    }
    return responseJson;
  }

  Future<dynamic> post(
      String urlSegment, String token, Map<String, dynamic> body) async {
    var responseJson;
    try {
      final response = await _client.post(_baseUrl + urlSegment,
          headers: _headers(token), body: json.encode(body));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw NoInternetException("No Internet connection. Try again later.");
    }
    return responseJson;
  }

  //TODO: Add more description
  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException();
      case 401:
      case 403:
        throw UnauthorizedException();
      case 404:
        throw NotFoundException();
      case 409:
        throw ConflictException();
      case 500:
      default:
        throw FetchDataException();
    }
  }
}
