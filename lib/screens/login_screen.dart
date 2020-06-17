import 'package:flutter/material.dart';

import 'package:foodload_flutter/services/auth.dart';
import 'landing_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  Widget _signInButton(BuildContext context, String imagePath, String text) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        dynamic res = await _auth.signInWithGoogle();
        if (res != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return Landing();
              },
            ),
          );
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage(imagePath), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              _signInButton(
                  context, 'assets/google_logo.png', 'Sign in with Google'),
            ],
          ),
        ),
      ),
    );
  }
}
