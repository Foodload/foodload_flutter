import 'package:flutter/material.dart';
import 'package:foodload_flutter/providers/auth.dart';
import 'package:foodload_flutter/services/auth.dart';
import 'package:provider/provider.dart';

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
                  Provider.of<Auth>(context, listen: false).signOutGoogle();
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
          color: Theme.of(context).buttonColor,
          child: Text(
            'Send Token',
            //style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          onPressed: () async {
            final token = await Provider.of<Auth>(context, listen: false).token;
            print(token);
//            final resp = await _auth.sendTokenToRest();
//            print(resp);
          },
        ),
      ),
    );
  }
}
