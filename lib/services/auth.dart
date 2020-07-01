import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

//Will be removed
class AuthService {
  /*Extract token*/
  Future<String> extractToken() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    IdTokenResult token = await user.getIdToken();
    return token.token;
  }

  /*Send X Req to REST API, prob refactor this soon*/
  Future<String> sendTokenToRest() async {
    final url = 'https://foodload.herokuapp.com/login'; //fill this
    var token = await extractToken();
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    Response resp = await get(url, headers: headers);
    int statusCode = resp.statusCode;
    print(statusCode);
    if (statusCode != 200) {
      return resp.body.toString();
    }
    print(resp.body);
    return resp.body;
  }
}
