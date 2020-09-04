import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/auth/auth_bloc.dart';
import 'package:foodload_flutter/helpers/keys.dart';
import 'package:foodload_flutter/models/storage_type.dart';
import 'package:foodload_flutter/ui/screens/search_item_screen.dart';
import 'package:foodload_flutter/ui/screens/test_screen.dart';
import 'package:foodload_flutter/ui/widgets/app_drawer.dart';
import 'package:foodload_flutter/ui/widgets/storage.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = '/';

  final fridge = const Storage(
    title: fridgeTitle,
    imagePath: fridgeImagePath,
    storageType: StorageType.Fridge,
  );

  final freezer = const Storage(
    title: freezerTitle,
    imagePath: freezerImagePath,
    storageType: StorageType.Freezer,
  );

  final pantry = const Storage(
    title: pantryTitle,
    imagePath: pantryImagePath,
    storageType: StorageType.Pantry,
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
      resizeToAvoidBottomInset: false,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text(landingScreenTitle),
        actions: <Widget>[
          DropdownButton(
            underline: Container(),
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
              DropdownMenuItem(
                child: Container(
                  child: const Text('Test'),
                ),
                value: 'test',
              ),
              DropdownMenuItem(
                child: Container(
                  child: const Text('Search Item'),
                ),
                value: 'search item',
              ),
            ],
            onChanged: (val) {
              switch (val) {
                case 'logout':
                  //Navigator.of(context).pushReplacementNamed('/'); //if logout should be possible from wherever
                  BlocProvider.of<AuthBloc>(context).add(
                    AuthLoggedOut(),
                  );
                  break;
                case 'test':
                  Navigator.of(context).pushNamed(TestScreen.routeName);
                  break;
                case 'search item':
                  //TODO: Remove this from here
                  Navigator.of(context).pushNamed(SearchItemScreen.routeName);
                  break;
                default:
                  print(val);
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
