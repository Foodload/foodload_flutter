import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  FirebaseUser _user;
  String _token;
  DateTime _tokenExpiryDate;

  FirebaseUser get user {
    return _user;
  }

  void init() async {
    _user = await _auth.currentUser();
    await updateToken();
  }

  Future<void> updateToken() async {
    if (_user != null) {
      final res = await _user.getIdToken(refresh: true);
      _token = res.token;
      _tokenExpiryDate = res.expirationTime;
      notifyListeners();
    } else {
      print("no user initated");
    }
  }

  Future<String> get token async {
    if (_tokenExpiryDate != null && _tokenExpiryDate.isBefore(DateTime.now())) {
      await updateToken();
    }

    if (_tokenExpiryDate != null &&
        _tokenExpiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
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
    } catch (error) {
      throw error;
    }
  }

  void signOutGoogle() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    notifyListeners();
  }
}
