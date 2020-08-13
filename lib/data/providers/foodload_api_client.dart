import 'dart:convert';

import 'package:foodload_flutter/helpers/keys.dart';
import 'package:foodload_flutter/models/exceptions/bad_response_exception.dart';
import 'package:foodload_flutter/models/item.dart';
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
    final resp = await http.get(backend_url + urlSegment, headers: headers);
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

  Future<void> addItemQR(String token, String qr, String storageType) async {
    const urlSegment = 'addItemQR';
    final headers = _headers(token);
    String json =
        '{"qrCode": "$qr", "storageType": "$storageType", "ammount": "1"}';
    final resp =
        await http.post(backend_url + urlSegment, headers: headers, body: json);
    int statusCode = resp.statusCode;
    if (statusCode != 200) {
      //TODO: Handle bad response message
      print(resp.body);
      throw BadResponseException('Something went wrong...');
    }
    return resp.body;
  }

  Future<String> removeItemQR(
      String token, String qr, String storageType) async {
    const urlSegment = 'removeItemQR';
    final headers = _headers(token);
    String json =
        '{"qrCode": "$qr", "storageType": "$storageType", "ammount": "1"}';
    final resp =
        await http.post(backend_url + urlSegment, headers: headers, body: json);
    int statusCode = resp.statusCode;
    if (statusCode != 200) {
      print(resp.body);
      throw Error();
    }
    print("RESP:" + resp.body);
    return resp.body;
  }

  Future<List<Item>> checkFridge(String token) async {
    const urlSegment = 'checkFridge';
    final headers = _headers(token);
    final resp = await http.get(backend_url + urlSegment, headers: headers);
    int statusCode = resp.statusCode;
    if (statusCode != 200) {
      //TODO: Handle bad response message
      print(resp.body);
      throw BadResponseException('Something went wrong...');
    }

    List<Item> fridgeItems = (jsonDecode(resp.body) as List)
        .map((jsonItem) => Item.fromJson(jsonItem))
        .toList();
    return fridgeItems;
  }

  Future<String> requestFamilyToken(String userToken) async {
    //const urlSegment = ''
  }
}
