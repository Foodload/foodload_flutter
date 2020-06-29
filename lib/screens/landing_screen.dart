import 'package:flutter/material.dart';
import 'package:foodload_flutter/services/auth.dart';

class Landing extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
          child: RaisedButton(
              child: Text('Send Token'),
              onPressed: () async {
                final resp = await _auth.sendTokenToRest();
                print(resp);
              })),
    );
  }
}
