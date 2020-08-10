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
    print(token);
    final resp = await http.get(backend_url + urlSegment, headers: headers);
    int statusCode = resp.statusCode;
    if (statusCode != 200) {
      print(resp.body);
      throw Error();
    }
    return resp.body;
  }

  Future<String> requestFamilyToken(String userToken) async {
    //const urlSegment = ''
  }
}
