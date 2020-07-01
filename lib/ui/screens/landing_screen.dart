import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/auth/auth_bloc.dart';
import 'package:foodload_flutter/blocs/item/bloc.dart';

class LandingScreen extends StatelessWidget {
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
                  BlocProvider.of<AuthBloc>(context).add(
                    AuthLoggedOut(),
                  );
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
          color: Theme.of(context).colorScheme.primary,
          child: Text(
            'Send Token',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          onPressed: () async {
            BlocProvider.of<ItemBloc>(context).add(
              SendToken(),
            );
          },
        ),
      ),
    );
  }
}
