import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/auth/auth_bloc.dart';
import 'package:foodload_flutter/ui/widgets/storage.dart';

class LandingScreen extends StatelessWidget {
  final fridge = const Storage(
    title: 'Fridge',
    imagePath: 'assets/fridge.jpg',
    namedRoute: '/fridge-screen',
  );

  final freezer = const Storage(
    title: 'Freezer',
    imagePath: 'assets/freezer.jpg',
    namedRoute: '/freezer-screen',
  );

  final pantry = const Storage(
    title: 'Pantry',
    imagePath: 'assets/pantry.jpg',
    namedRoute: '/pantry-screen',
  );

  Widget _buildLandscapeContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        fridge,
        freezer,
        pantry,
      ],
    );
  }

  Widget _buildPortraitContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        fridge,
        freezer,
        pantry,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _isLandscape = _mediaQuery.orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: <Widget>[
          DropdownButton(
            icon: const Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.exit_to_app),
                      const SizedBox(width: 8),
                      const Text('Logout'),
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
        child:
            _isLandscape ? _buildLandscapeContent() : _buildPortraitContent(),
      ),
    );
  }
}
