import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/auth/auth_bloc.dart';
import 'package:foodload_flutter/helpers/keys.dart';
import 'package:foodload_flutter/ui/screens/test_screen.dart';
import 'package:foodload_flutter/ui/widgets/app_drawer.dart';
import 'package:foodload_flutter/ui/widgets/storage_icon_link.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = '/';

  final fridgeWidget = const StorageIconLink(
    title: fridge,
    imagePath: fridgeImagePath,
    storageType: fridge,
  );

  final freezerWidget = const StorageIconLink(
    title: freezer,
    imagePath: freezerImagePath,
    storageType: freezer,
  );

  final pantryWidget = const StorageIconLink(
    title: pantry,
    imagePath: pantryImagePath,
    storageType: pantry,
  );

  Widget _buildLandscapeContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        fridgeWidget,
        freezerWidget,
        pantryWidget,
      ],
    );
  }

  Widget _buildPortraitContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        fridgeWidget,
        freezerWidget,
        pantryWidget,
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
