import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodload_flutter/services/auth.dart';

class LandingScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: <Widget>[
          DropdownButton(
            icon: Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemId) {
              switch (itemId) {
                case 'logout':
                  FirebaseAuth.instance.signOut();
                  break;
                default:
                  print(itemId);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Send Token'),
          onPressed: () async {
            final resp = await _auth.sendTokenToRest();
            print(resp);
          },
        ),
      ),
    );
  }
}
