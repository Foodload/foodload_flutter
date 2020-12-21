import 'dart:convert';

import 'package:foodload_flutter/helpers/keys.dart';
import 'package:foodload_flutter/models/exceptions/bad_request_exception.dart';
import 'package:foodload_flutter/models/exceptions/internal_server_error_exception.dart';
import 'package:foodload_flutter/models/exceptions/not_found_exception.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/models/item_info.dart';
import 'package:foodload_flutter/models/move_item_info.dart';
import 'package:foodload_flutter/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class FoodloadApiClient {
  final http.Client httpClient;

  FoodloadApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Map<String, String> _headers(String token) {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    return headers;
  }

  Map<String, dynamic> _itemBody(
      String qrCode, String storageType, int amount) {
    Map<String, dynamic> body = {
      'qrCode': qrCode,
      'storageType': storageType,
      'amount': amount,
    };
    return body;
  }

  Future<User> sendInit(String token) async {
    const urlSegment = 'login';
    final headers = _headers(token);
    final resp = await http.get(backendURL + urlSegment, headers: headers);
    int statusCode = resp.statusCode;
    if (statusCode != 200) {
      //TODO: Handle bad response message
      print(resp.body);
      throw BadResponseException('Something went wrong...');
    }
    final decode = jsonDecode(resp.body);
    final user = User(
      token: decode['token'],
      email: decode['client']['email'],
      familyId: decode['client']['family']['id'],
      familyName: decode['client']['family']['name'],
    );
    return user;
  }

  Future<void> addItemQR(
      {String qr, int amount, String storageType, String token}) async {
    const urlSegment = 'add-item';
    final headers = _headers(token);
    Map<String, dynamic> body = {
      'qrCode': qr,
      'amount': amount,
      'storageType': storageType,
    };
    final resp = await http.post(backendURL + urlSegment,
        headers: headers, body: json.encode(body));
    int statusCode = resp.statusCode;
    if (statusCode != 200) {
      //TODO: Handle bad response message
      print(resp.body);
      throw BadResponseException('Something went wrong...');
    }
  }

  Future<String> removeItemQR(
      String token, String qr, String storageType) async {
    const urlSegment = 'removeItemQR';
    final headers = _headers(token);
    String json =
        '{"qrCode": "$qr", "storageType": "$storageType", "amount": "1"}';
    final resp =
        await http.post(backendURL + urlSegment, headers: headers, body: json);
    int statusCode = resp.statusCode;
    if (statusCode != 200) {
      print(resp.body);
      throw Error();
    }
    print("RESP:" + resp.body);
    return resp.body;
  }

  Future<List<Item>> getItemCounts(String token) async {
    const urlSegment = 'get-all-item-counts';
    final headers = _headers(token);
    final resp = await http.get(backendURL + urlSegment, headers: headers);
    int statusCode = resp.statusCode;
    if (statusCode != 200) {
      //TODO: Handle bad response message
      print(resp.body);
      throw BadResponseException('Something went wrong...');
    }
    print(resp.headers);
    print(resp.body);
    List<Item> fridgeItems = (jsonDecode(resp.body) as List)
        .map((jsonItem) => Item.fromJson(jsonItem))
        .toList();
    return fridgeItems;
  }

  Future<void> incrementItem(String token, int id) async {
    const urlSegment = 'increment-item';
    final headers = _headers(token);
    Map<String, dynamic> body = {
      'id': id,
    };
    final resp = await http.post(
      backendURL + urlSegment,
      headers: headers,
      body: json.encode(body),
    );
    int statusCode = resp.statusCode;
    if (statusCode != 200) {
      //TODO: Handle bad response
      print(resp.body);
      throw BadResponseException('Something went wrong...');
    }
  }

  Future<void> decrementItem(String token, int id) async {
    const urlSegment = 'decrement-item';
    final headers = _headers(token);
    Map<String, dynamic> body = {
      'id': id,
    };
    final resp = await http.post(
      backendURL + urlSegment,
      headers: headers,
      body: json.encode(body),
    );
    int statusCode = resp.statusCode;
    if (statusCode != 200) {
      //TODO: Handle bad response
      print(resp.body);
      throw BadResponseException('Something went wrong...');
    }
  }

  Future<List<ItemInfo>> findItemByName(
      String searchText, int startIndex, String userToken) async {
    const urlSegment = 'find-item-by-name';
    final headers = _headers(userToken);
    Map<String, dynamic> body = {
      'name': searchText,
      'start': startIndex,
    };

    final resp = await http.post(
      backendURL + urlSegment,
      headers: headers,
      body: json.encode(body),
    );
    int statusCode = resp.statusCode;
    if (statusCode != 200) {
      //TODO: Handle bad response
      print(resp.body);
      throw BadResponseException('Something went wrong...');
    }
    //print(resp.body);
    List<ItemInfo> results = (jsonDecode(resp.body) as List)
        .map((jsonItem) => ItemInfo.fromJson(jsonItem))
        .toList();
    return results;
  }

  Future<ItemInfo> findItemByQr(String qr, String userToken) async {
    const urlSegment = 'search-item';
    final headers = _headers(userToken);
    Map<String, dynamic> body = {'qrCode': qr};
    final resp = await http.post(backendURL + urlSegment,
        headers: headers, body: json.encode(body));
    int statusCode = resp.statusCode;
    final jsonItem = jsonDecode(resp.body);
    if (statusCode != 200) {
      final errorMsg = jsonItem['message'];
      if (statusCode == 404) {
        throw NotFoundException(errorMsg);
      } else if (statusCode == 400) {
        throw BadResponseException(errorMsg);
      } else if (statusCode == 500) {
        throw InternalServerErrorException(errorMsg);
      } else {
        throw Exception('Ops, something went wrong. Please try again.');
      }
    }
    final itemInfo = ItemInfo.fromJson(jsonItem);
    return itemInfo;
  }

  Future<MoveItemInfo> moveItemToStorage(
      {String userToken,
      int id,
      String storageType,
      int oldAmount,
      int moveAmount}) async {
    const urlSegment = 'move-item-to';
    final headers = _headers(userToken);
    Map<String, dynamic> body = {
      'itemCountId': id,
      'storageType': storageType,
      'moveAmount': moveAmount,
      'oldAmount': oldAmount,
    };
    final resp = await http.post(backendURL + urlSegment,
        headers: headers, body: json.encode(body));

    if (resp.statusCode != 200) {
      throw Exception('Handle other cases (400, dirty read)');
      //TODO: Handle other cases (400, dirty read)
    } else {
      final jsonItem = jsonDecode(resp.body);
      return MoveItemInfo.fromJson(jsonItem);
    }
  }

  Future<MoveItemInfo> moveItemFromStorage(
      {String userToken,
      int id,
      String storageType,
      int oldAmount,
      int moveAmount}) async {
    const urlSegment = 'move-item-from';
    final headers = _headers(userToken);
    Map<String, dynamic> body = {
      'itemCountId': id,
      'storageType': storageType,
      'moveAmount': moveAmount,
      'oldAmount': oldAmount,
    };
    final resp = await http.post(backendURL + urlSegment,
        headers: headers, body: json.encode(body));

    if (resp.statusCode != 200) {
      throw Exception('Handle other cases (400, dirty read)');
      //TODO: Handle other cases (400, dirty read)
    } else {
      final jsonItem = jsonDecode(resp.body);
      return MoveItemInfo.fromJson(jsonItem);
    }
  }

  Future<String> requestFamilyToken(String userToken) async {
    //const urlSegment = ''
  }
}
