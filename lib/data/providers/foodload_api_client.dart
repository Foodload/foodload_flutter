import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class FoodloadApiClient {
  static const baseUrl = 'https://foodload.herokuapp.com/';
  final http.Client httpClient;

  FoodloadApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<String> sendToken(String token) async {
    const urlSegment = 'login';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final resp = await http.get(baseUrl + urlSegment, headers: headers);
    int statusCode = resp.statusCode;
    print(statusCode);
    if (statusCode != 200) {
      return resp.body.toString();
    }
    print(resp.body);
    return resp.body;
  }
}
