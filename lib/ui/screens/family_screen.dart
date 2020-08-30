import 'package:flutter/material.dart';
import 'package:foodload_flutter/ui/widgets/app_drawer.dart';

class FamilyScreen extends StatelessWidget {
  static const routeName = '/family-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family'),
      ),
      drawer: AppDrawer(),
      body: Center(),
    );
  }
}
