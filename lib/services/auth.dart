import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      return 'signInWithGoogle succeeded: $user';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");

    //FirebaseAuth.instance.signOut();??? Why not?
  }

  /*Extract token*/
  Future<String> extractToken() async {
    FirebaseUser user = await _auth.currentUser();
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
