import 'package:foodload_flutter/helpers/keys.dart';
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

  Future<String> sendInit(String token) async {
    const urlSegment = 'login';
    final headers = _headers(token);

    final resp = await http.get(backend_url + urlSegment, headers: headers);
    int statusCode = resp.statusCode;
    if (statusCode != 200) {
      print(resp.body);
      throw Error();
    }
    print("RESP:" + resp.body);
    return resp.body;
  }

  Future<String> addItemQR(String token, String qr, String storageType) async {
    const urlSegment = 'addItemQR';
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

  Future<String> checkFridge(String token) async {
    const urlSegment = 'checkFridge';
    final headers = _headers(token);
    final resp = await http.get(backend_url + urlSegment, headers: headers);
    int statusCode = resp.statusCode;
    if (statusCode != 200) {
      print(resp.body);
      throw Error();
    }
    print("RESP:" + resp.body);
    return resp.body;
  }

  Future<String> requestFamilyToken(String userToken) async {
    //const urlSegment = ''
  }
}
