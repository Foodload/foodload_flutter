import 'package:flutter/material.dart';
import 'package:foodload_flutter/helpers/keys.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const _DrawerHeader(),
            _DrawerListItem(
              icon: Icons.fastfood,
              title: 'Templates',
              nav: () {
                // Navigator.of(context)
                //     .pushReplacementNamed(TestScreen.routeName);
              },
            ),
            _DrawerListItem(
              icon: Icons.settings,
              title: 'Settings',
              nav: () {
                // Navigator.of(context)
                //     .pushReplacementNamed(TestScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget _createHeader() {
  //   return DrawerHeader(
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //         fit: BoxFit.fill,
  //         image: AssetImage(pantry_image_path),
  //       ),
  //     ),
  //     padding: const EdgeInsets.all(0.0),
  //     child: Stack(
  //       children: <Widget>[
  //         Column(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: <Widget>[
  //             Container(
  //               alignment: Alignment.center,
  //               color: Colors.black54,
  //               padding: const EdgeInsets.symmetric(
  //                 vertical: 5,
  //               ),
  //               child: Text(
  //                 'Foodload',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 20.0,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _createItem({IconData icon, String text, GestureTapCallback onTap}) {
  //   return ListTile(
  //     title: Row(
  //       children: <Widget>[
  //         Icon(icon),
  //         Padding(
  //           padding: EdgeInsets.only(left: 8.0),
  //           child: Text(text),
  //         )
  //       ],
  //     ),
  //     onTap: onTap,
  //   );
  // }
}

class _DrawerHeader extends StatelessWidget {
  final backgroundImage = const AssetImage(pantry_image_path);
  final title = 'Foodload';

  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: backgroundImage,
        ),
      ),
      padding: const EdgeInsets.all(0.0),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function nav;

  const _DrawerListItem({this.icon, this.title, this.nav});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(icon),
              const SizedBox(
                width: 10,
              ),
              Text(title),
            ],
          ),
          onTap: nav,
        ),
        Divider(),
      ],
    );
  }
}
