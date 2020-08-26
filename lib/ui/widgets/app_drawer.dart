import 'package:flutter/material.dart';
import 'package:foodload_flutter/helpers/keys.dart';
import 'package:foodload_flutter/ui/screens/test_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createItem(
              icon: Icons.note,
              text: 'Test sida',
              onTap: () =>
                  Navigator.of(context).pushNamed(TestScreen.routeName)),
          Divider(),
          _createItem(
              icon: Icons.tab,
              text: 'Test 2',
              onTap: () =>
                  Navigator.of(context).pushNamed(TestScreen.routeName)),
          Divider(),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(pantry_image_path),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0, // KANSKE CENTERED SNYGGARE?
              child: Container(
                alignment: Alignment.center,
                color: Colors.black54,
                width: 270,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Text(
                  "Foodload Navigation",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                ),
              )),
        ],
      ),
    );
  }

  Widget _createItem({IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
