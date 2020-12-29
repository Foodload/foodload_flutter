import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodload_flutter/data/providers/foodload_api_client.dart';
import 'package:foodload_flutter/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FoodloadApiClient _foodloadApiClient;
  User foodloadUser;

  UserRepository(
      {FirebaseAuth firebaseAuth,
      GoogleSignIn googleSignIn,
      FoodloadApiClient foodloadApiClient})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _foodloadApiClient = foodloadApiClient ?? FoodloadApiClient();

  bool get isInit => foodloadUser != null;

  Future<FirebaseUser> signInWithGoogle() async {
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
          await _firebaseAuth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      assert(user.uid == currentUser.uid);
      return currentUser;
    } catch (error) {
      throw error;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    //TODO: Set foodloadUser to null?
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getUser() async {
    return await _firebaseAuth.currentUser();
  }

  Future<String> getToken() async {
    //TODO: Refresh token?
    final user = await getUser();
    final tokenRes = await user.getIdToken();
    return tokenRes.token;
  }

  Future<void> initUser() async {
    try {
      final user = await _foodloadApiClient.sendInit(await getToken());
      foodloadUser = user;
    } catch (error) {
      //TODO: Maybe create more exceptions, more business logic related?
      throw error;
    }
  }
}
